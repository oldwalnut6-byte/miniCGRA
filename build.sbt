ThisBuild / scalaVersion := "2.13.7"
Compile / scalaSource := baseDirectory.value / "src" / "scala"
libraryDependencies += "edu.berkeley.cs" %% "chisel3" % "3.5.4"
addCompilerPlugin(
  "edu.berkeley.cs" % "chisel3-plugin" % "3.5.4" cross CrossVersion.full
)
