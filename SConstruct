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

env = Environment(variables=env_vars)

if env["FAUST_ARCHITECTURE"].endswith("qt"):
    env.Tool("qt4")

faust_tool = Tool("faust")

# verify that FAUST is installed and exit if not
if not faust_tool.exists(env):
    print("FAUST is not available! Please install it first.")
    env.Exit()

faust_tool(env)

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
    env.Append(LIBS = ["portaudio"])

elif env["FAUST_ARCHITECTURE"] == "pa-gtk":

    env.MergeFlags(["!pkg-config --cflags-only-I gtk+-2.0"])
    env.Append(LIBS = ["portaudio", "gtk-x11-2.0"])

elif env["FAUST_ARCHITECTURE"] == "jack-qt":

    env.EnableQt4Modules(["QtGui", "QtCore"])
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
    FAUST_FLAGS = ["-t", "4800"],
)

# Work around FAUST2 crashing
if env['FAUST_VERSION'] < "2":
    env.Append(FAUST_FLAGS = "-vec")

# parallelization flags
if env["CXX"] == "g++" and env["CXXVERSION"] >= "4.5":
    env.Append(CCFLAGS=[
        "-ftree-vectorize",
        # "-ftree-vectorizer-verbose=2",
        "-floop-interchange",
        "-floop-strip-mine",
        "-floop-block",
    ])

######################
# Compile everything #
######################

rmfb, svgs, mbstereophony = env.SConscript(
    dirs='src',
    variant_dir = "build",
    exports     = "env",
    duplicate   = False
)

#################
# Miscellaneous #
#################

env.Alias("mbstereophony", mbstereophony)
env.Alias("rmfb", rmfb)
env.Alias("all-svg", svgs)
env.Alias("all", mbstereophony + rmfb)

Default("mbstereophony")

Help(
"""This build system compiles MBStereophony and related programs.  To compile,
use one of the following build targets:

    mbstereophony{s,d}_{sum,syn} -> compile one of the mbstereophony* effects
    mbstereophony                -> compile all of the mbstereophony* effects (default)
    rmfb{s,d}_{sum,syn}          -> compile one of the rmfb* filter bank programs
    rmfb                         -> compile all of the rmfb* filter bank programs
    <target>-svg                 -> generate SVGs of <target>
    all-svg                      -> generate SVGs of all targets
    all                          -> compile all of the above

The following environment variables can be overridden by passing them *after*
the call to scons, e.g., "scons CC=gcc":
"""
+ env_vars.GenerateHelpText(env)
)
