{ lib, ... }:
{
  relativeToRoot = lib.path.append ../.;
  # Recursive function to scan paths and subdirectories (files only, excluding root default.nix)
  scanPathsRecursive =
    path:
    let
      allFiles = lib.filesystem.listFilesRecursive path;
      rootPath = toString path;
    in
    builtins.filter (
      file:
      let
        fileName = baseNameOf file;
        filePath = toString file;
      in
      (lib.strings.hasSuffix ".nix" fileName)
      &&
        # Exclude default.nix only if it's directly in the root path being scanned
        !(fileName == "default.nix" && (dirOf filePath) == rootPath)
    ) allFiles;
  # Non-recursive version (your original logic)
  scanPaths =
    path:
    builtins.map (f: (path + "/${f}")) (
      builtins.attrNames (
        lib.attrsets.filterAttrs (
          path: _type:
          (_type == "directory") # include directories
          || (lib.strings.hasSuffix ".nix" path) # include all .nix files
        ) (builtins.readDir path)
      )
    );
}
