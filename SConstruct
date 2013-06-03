valid_faust_arches = frozenset((
    "bench",
    "sndfile",
    "pa-qt",
    "pa-gtk",
    "jack-qt",
    "jack-gtk",
    "puredata",
))

valid_concurrencies = frozenset((
    "",
    "openmp",
    "wss",
))

##########################
# Environment definition #
##########################

env_vars = Variables()
env_vars.AddVariables(
    EnumVariable("FAUST_ARCHITECTURE",
                 "The FAUST architecture",
                 "jack-qt", valid_faust_arches),
    BoolVariable("osc", "Use Open Sound Control (OSC)", True),
    EnumVariable("concurrency", "FAUST's method of concurrency",
                 "", valid_concurrencies),
    ("FAUST_FLAGS", "FAUST compiler flags"),
    ("CXX", "The C++ compiler"),
    ("CCFLAGS", "Extra flags to pass to the C and C++ compiler", "", None, str.split),
    ("CXXFLAGS", "Extra flags to pass to the C++ compiler", "", None, str.split),
)

env = Environment(tools=["default", "faust"],
                  variables=env_vars)

if env["FAUST_ARCHITECTURE"].endswith("qt"):
    env.Tool("qt4")

#############################
# Environment configuration #
#############################

if env["osc"]:

    env.Append(
        CPPDEFINES = ["OSCCTRL"],
        CPPPATH = ["/usr/lib/faust"],
        LIBPATH = ["/usr/lib/faust"],
        # NOTE: The order matters!
        LIBS = ["OSCFaust", "oscpack"],
    )

if env["concurrency"] == "openmp":

    env.Append(
        CCFLAGS = ["-fopenmp"],
        FAUST_FLAGS = ["-omp"],
        LIBS = ["gomp"],
    )

elif env["concurrency"] == "wss":

    env.Append(
        FAUST_FLAGS = ["-sch"],
    )

if env["FAUST_ARCHITECTURE"] == "pa-qt":

    env.EnableQt4Modules(["QtGui", "QtCore"])
    faustqt = env.Moc4("faustqt", "/usr/include/faust/gui/faustqt.h")

    env.Append(LIBS = ["portaudio"])

elif env["FAUST_ARCHITECTURE"] == "pa-gtk":

    env.MergeFlags(["!pkg-config --cflags-only-I gtk+-2.0"])
    env.Append(LIBS = ["portaudio", "gtk-x11-2.0"])

elif env["FAUST_ARCHITECTURE"] == "jack-qt":

    env.EnableQt4Modules(["QtGui", "QtCore"])
    faustqt = env.Moc4("faustqt", "/usr/include/faust/gui/faustqt.h")

    env.Append(LIBS = ["jack"])

elif env["FAUST_ARCHITECTURE"] == "jack-gtk":

    # Use pkg-config to get the required include paths (includes some
    # unnecessary paths, but what the hell)
    env.MergeFlags(["!pkg-config --cflags-only-I gtk+-2.0"])
    env.Append(LIBS = ["jack", "gtk-x11-2.0"])

elif env["FAUST_ARCHITECTURE"] == "sndfile":

    env.Append(LIBS = ["sndfile"])

env.Append(
    CPPPATH = [env["FAUST_PATH"], "/usr/share/include"],
)

# prepend so that you can override these if necessary
env.Prepend(
    CCFLAGS     = ["-O3", "-pedantic", "-march=native",
                   "-Wall", "-Wextra", "-Wno-unused-parameter"],
    CXXFLAGS    = ["-std=c++0x"],
    LINKFLAGS   = ["-Wl,--as-needed"],
    FAUST_FLAGS = ["-vec", "-t", "4800"],
)

# parallelization flags
if env["CXX"] == "g++" and env["CXXVERSION"] >= "4.5":
    env.Append(CCFLAGS=[
        "-ftree-vectorize",
        # "-ftree-vectorizer-verbose=2",
        "-floop-interchange",
        "-floop-strip-mine",
        "-floop-block",
    ])

######################################################
# MBStereophony effect and Regalia-Mitra filter bank #
######################################################

mbst_dsp = env.Glob("mbstereophony*.dsp")
rmfb_dsp = env.Glob("rmfb*.dsp")

rmfb = []
mbstereophony = []
for dsp in mbst_dsp+rmfb_dsp:
    dsp_name = str(dsp).rsplit(".")[0]

    c_src = [env.Faust(dsp)]
    if env["FAUST_ARCHITECTURE"] in ("jack-qt", "pa-qt"):
        c_src.append(faustqt)

    if env["FAUST_ARCHITECTURE"] == "puredata":
        cur_dsp = env.SharedLibrary(
            c_src,
            SHLIBPREFIX="",
            SHLIBSUFFIX="~.pd_linux"
        )
    else:
        cur_dsp = env.Program(c_src)

    if dsp_name.startswith("mbstereophony"):
        mbstereophony.append(cur_dsp)
    else:
        rmfb.append(cur_dsp)

    env.Alias(dsp_name, cur_dsp)

#################
# Miscellaneous #
#################

env.Alias("mbstereophony", mbstereophony)
env.Alias("rmfb", rmfb)
env.Alias("all", mbstereophony + rmfb)

Default("mbstereophony")

Help(
"""This build system compiles MBStereophony and related programs.  To compile,
use one of the following build targets:

    mbstereophony{s,d}_{sum,syn} -> compile one of the mbstereophony* effects
    mbstereophony                -> compile all of the mbstereophony* effects (default)
    rmfb{s,d}_{sum,syn}          -> compile one of the rmfb* filter bank programs
    rmfb                         -> compile all of the rmfb* filter bank programs
    all                          -> compile all of the above

The following environment variables can be overridden by passing them *after*
the call to scons, e.g., "scons CC=gcc":
"""
+ env_vars.GenerateHelpText(env)
)
