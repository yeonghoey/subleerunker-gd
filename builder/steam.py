APP = """
"appbuild"
{
	"appid"	"1167150"
	"desc" "Your build description here" // description for this build
	"buildoutput" "../output/" // build output folder for .log, .csm & .csd files, relative to location of this file
	"setlive"	"" // branch to set live after successful build, non if empty
	"preview" "0" // to enable preview builds
	"local"	""	// set to flie path of local content server 
	
	"depots"
	{
		"1167151" "depot_build_1167151.vdf"
		"1167152" "depot_build_1167152.vdf"
	}
}
"""

DEPOT_MACOS = """
"DepotBuildConfig"
{
	// Set your assigned depot ID here
	"DepotID" "1167151"

	// Set a root for all content.
	// All relative paths specified below (LocalPath in FileMapping entries, and FileExclusion paths)
	// will be resolved relative to this root.
	// If you don't define ContentRoot, then it will be assumed to be
	// the location of this script file, which probably isn't what you want
	"ContentRoot"	"../content/macos/"

	// include all files recursivley
  "FileMapping"
  {
  	// This can be a full path, or a path relative to ContentRoot
    "LocalPath" "*"
    
    // This is a path relative to the install folder of your game
    "DepotPath" "."
    
    // If LocalPath contains wildcards, setting this means that all
    // matching files within subdirectories of LocalPath will also
    // be included.
    "recursive" "1"
  }
  "FileExclusion" ".DS_Store"
}
"""

DEPOT_WINDOWS = """
"DepotBuildConfig"
{
	// Set your assigned depot ID here
	"DepotID" "1167152"

	// Set a root for all content.
	// All relative paths specified below (LocalPath in FileMapping entries, and FileExclusion paths)
	// will be resolved relative to this root.
	// If you don't define ContentRoot, then it will be assumed to be
	// the location of this script file, which probably isn't what you want
	"ContentRoot"	"../content/windows/"

	// include all files recursivley
  "FileMapping"
  {
  	// This can be a full path, or a path relative to ContentRoot
    "LocalPath" "*"
    
    // This is a path relative to the install folder of your game
    "DepotPath" "."
    
    // If LocalPath contains wildcards, setting this means that all
    // matching files within subdirectories of LocalPath will also
    // be included.
    "recursive" "1"
  }
  "FileExclusion" ".DS_Store"
}
"""
