# WSL Configuration Guide

This guide provides suggestions for making your NixOS configuration WSL-friendly by avoiding GUI applications and desktop environments.

## Current Issues for WSL

Your current configuration includes several GUI components that won't work well in WSL:

1. **Desktop Environment**: Hyprland (Wayland compositor)
2. **Display Manager**: SDDM 
3. **GUI Applications**: Firefox, VSCode, Obsidian, Spotify, Discord, etc.
4. **Terminal Emulator**: Kitty (GUI-based)
5. **Application Launcher**: Rofi
6. **Desktop Apps**: Calculator, file managers

## Suggested Solutions

### 1. Create a WSL-Specific User Configuration

Create a new user configuration file specifically for WSL:

```bash
# Create: /home/mikke/nix/users/mikke-wsl.nix
```

This would disable all GUI components and only enable CLI tools.

### 2. Modify Your Flake to Support WSL Mode

In your `flake.nix`, you could add a WSL-specific home configuration that uses different modules:

```nix
homeConfigurations.mikke-wsl = home-manager.lib.homeManagerConfiguration {
  pkgs = nixpkgs.legacyPackages.${system};
  extraSpecialArgs = {hostName = "wsl";};
  modules = [
    ./users/mikke-wsl.nix  # WSL-specific config
    nvf.homeManagerModules.default
  ];
};
```

### 3. WSL-Specific Feature Flags

Create a WSL detection mechanism in your modules. You could:

- Use the `hostName = "wsl"` to conditionally enable/disable features
- Add a `wsl.enable` option to your feature system
- Create WSL-specific module variants

### 4. CLI-Only Alternatives

For WSL, you should use:

**Instead of GUI apps, use CLI alternatives:**
- `firefox` → `lynx`, `w3m`, or `curl`/`wget`
- `vscode` → `vim`, `neovim`, or `micro`
- `obsidian` → `vim` with markdown plugins or `glow`
- `spotify` → `spotify-tui` or `ncspot`
- `discord` → `discordo` or `discord-cli`
- `kitty` → Use Windows Terminal or WSL's built-in terminal

**Keep CLI tools that work well:**
- `git`, `curl`, `wget`, `jq`, `ripgrep`, `fd`
- `neovim`, `vim`, `micro`
- `zsh` with your configuration
- `nvf` (Neovim version manager)

### 5. Conditional Module Loading

Modify your modules to check for WSL environment:

```nix
# In your modules, add WSL detection
let
  isWSL = config.home.username == "mikke" && 
          (builtins.hasAttr "hostName" config && config.hostName == "wsl");
in
{
  config = lib.mkIf (!isWSL) {
    # GUI-specific configuration
  };
}
```

### 6. Recommended WSL Configuration Structure

For WSL, you'd want:

```nix
# users/mikke-wsl.nix
{
  features = {
    editors = {
      neovim.enable = true;  # CLI editor
      cursor-cli.enable = true;  # CLI version
    };
    
    # Disable all GUI components
    browsers.firefox.enable = false;
    desktopenv.hyprland.enable = false;
    apps.enable = false;
    applicationLaunchers.rofi.enable = false;
    terminalEmulators.kitty.enable = false;
    
    # Keep CLI tools
    programmingLanguages.enable = true;
    shell.zsh.enable = true;
  };
}
```

### 7. Build Commands for Different Environments

You could create different build targets:

```bash
# For full NixOS system
nixos-rebuild switch --flake .#home

# For WSL (Home Manager only)
home-manager switch --flake .#mikke-wsl
```

## Implementation Strategy

1. **Start Small**: Begin by creating a WSL-specific user configuration
2. **Test Incrementally**: Test each change to ensure it works in WSL
3. **Use Feature Flags**: Leverage your existing feature system to conditionally enable/disable components
4. **CLI-First**: Focus on CLI alternatives for all functionality
5. **Environment Detection**: Use `hostName` or other environment variables to detect WSL

## Additional Considerations

- **Performance**: CLI tools generally perform better in WSL
- **Compatibility**: Some packages may not work in WSL due to missing system services
- **Windows Integration**: Consider how your CLI tools integrate with Windows (file paths, clipboard, etc.)
- **Terminal**: Use Windows Terminal or WSL's built-in terminal instead of GUI terminal emulators

## Resources

- [WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [Home Manager WSL Guide](https://nix-community.github.io/home-manager/)
- [NixOS WSL Module](https://github.com/NixOS/nixpkgs/tree/master/nixos/modules/profiles/wsl)