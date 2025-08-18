{ lib, ... }:
{
  relativeToRoot = lib.path.append ../.;
  
  # Recursive function to scan paths and subdirectories
  scanPathsRecursive = 
    let
      scanRec = path:
        let
          entries = builtins.readDir path;
          
          # Filter for .nix files (excluding default.nix) and directories
          relevantEntries = lib.attrsets.filterAttrs (
            name: type:
              (type == "directory") # include directories for recursion
              || (
                (name != "default.nix") # ignore default.nix
                && (lib.strings.hasSuffix ".nix" name) # include .nix files
              )
          ) entries;
          
          # Process each entry
          processEntry = name: type:
            let
              fullPath = path + "/${name}";
            in
              if type == "directory" then
                # Recursively scan subdirectory
                scanRec fullPath
              else
                # It's a .nix file, return the path
                [ fullPath ];
                
          # Get all results and flatten the list
          allResults = builtins.map (name: processEntry name relevantEntries.${name}) (builtins.attrNames relevantEntries);
          
        in
          lib.lists.flatten allResults;
    in
      scanRec;
      
  # Non-recursive version (your original logic)
  scanPaths = path:
    builtins.map (f: (path + "/${f}")) (
      builtins.attrNames (
        lib.attrsets.filterAttrs (
          path: _type:
            (_type == "directory") # include directories
            || (
              (path != "default.nix") # ignore default.nix
              && (lib.strings.hasSuffix ".nix" path) # include .nix files
            )
        ) (builtins.readDir path)
      )
    );
}