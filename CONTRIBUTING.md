# Contributing to Lightroom Ratio Creator

Thank you for your interest in contributing to Lightroom Ratio Creator! This document provides guidelines and information for contributors.

## 🤝 Ways to Contribute

### 🐛 Reporting Bugs
- Use the [GitHub Issues](https://github.com/woutervellekoop/lightroom-ratio-creator/issues) page
- Check if the issue already exists before creating a new one
- Include detailed steps to reproduce the bug
- Provide information about your system (Lightroom version, OS, etc.)
- Include screenshots if applicable

### 💡 Suggesting Features
- Open a feature request on GitHub Issues
- Describe the use case you're trying to solve
- Explain what aspect ratios or platforms you'd like supported
- Consider how it fits with existing functionality
- Be open to discussion and refinement

### 📐 Requesting New Aspect Ratios
We love adding support for new platforms and formats! When requesting new ratios:
- Specify the exact ratio (e.g., 4:5, 16:9)
- Mention the platform/use case (e.g., LinkedIn posts, Pinterest pins)
- Provide documentation or reference links if available
- Consider both landscape and portrait orientations

### 🔧 Code Contributions
- Fork the repository
- Create a feature branch from `main`
- Make your changes
- Test thoroughly with Lightroom Classic
- Submit a pull request with a clear description

## 🛠️ Development Setup

### Prerequisites
- Adobe Lightroom Classic 10.0 or higher
- Text editor or IDE (VS Code recommended)
- Basic understanding of Lua programming
- Familiarity with Lightroom SDK

### Getting Started
1. Fork and clone the repository
```bash
git clone https://github.com/yourusername/lightroom-ratio-creator.git
cd lightroom-ratio-creator
```

2. Install the plugin in Lightroom
   - Open Lightroom Classic
   - Go to File > Plug-in Manager
   - Click "Add" and select the `.lrplugin` folder
   - Enable the plugin

3. Make your changes
   - Edit the `.lua` files in your preferred editor
   - Main file: `CreateRatioCopies.lua` - Core ratio creation logic
   - Test files: Use for debugging and testing new features

4. Test in Lightroom
   - Reload the plugin in Plug-in Manager after changes
   - Test with various image orientations and sizes
   - Verify virtual copies are created correctly

## 📝 Code Guidelines

### Lua Style
- Use 2 spaces for indentation
- Follow existing naming conventions
- Add comments for complex logic
- Keep functions focused and single-purpose

### Adding New Aspect Ratios
When adding new ratios, update these areas:
1. Add ratio definition to the ratios table
2. Include user-friendly name and description
3. Consider orientation handling
4. Test with both landscape and portrait images

### Example Code Style
```lua
-- Good: Clear ratio definition with metadata
local ratios = {
  {
    name = "Instagram Square",
    ratio = 1/1,
    category = "social",
    platforms = {"Instagram"},
    description = "Classic Instagram posts"
  }
}
```

### Testing
- Test with different image orientations (landscape, portrait, square)
- Verify virtual copies are created correctly
- Check that crop positioning works as expected
- Test batch operations with multiple selected photos
- Ensure plugin works with both RAW and processed images

## 🚀 Pull Request Process

1. **Create a descriptive title**
   - "Add Pinterest aspect ratio support"
   - "Fix crop positioning for portrait images"

2. **Write a clear description**
   - What problem does this solve?
   - How did you test the changes?
   - Any new aspect ratios added?

3. **Keep changes focused**
   - One feature or fix per pull request
   - Avoid mixing unrelated changes

4. **Update documentation**
   - Update README.md if adding new ratios
   - Add entries to CHANGELOG.md
   - Update code comments as needed

## 🔍 Review Process

- All pull requests will be reviewed before merging
- Feedback may be provided for improvements
- Changes may be requested for code style or functionality
- Be patient and responsive to feedback

## 📚 Resources

### Lightroom SDK Documentation
- [Adobe Lightroom SDK Guide](https://developer.adobe.com/lightroom/classic/)
- [Lua Programming Guide](https://www.lua.org/manual/5.1/)
- [Virtual Copy API Reference](https://developer.adobe.com/lightroom/classic/sdk/)

### Aspect Ratio References
- [Social Media Sizes Guide](https://blog.hootsuite.com/social-media-image-sizes-guide/)
- [Print Format Standards](https://en.wikipedia.org/wiki/Aspect_ratio_(image))
- Platform-specific documentation (Instagram, TikTok, etc.)

### Community
- [Lightroom Plugin Development Forum](https://community.adobe.com/t5/lightroom-classic/bd-p/lightroom-classic)
- [Content Creator Communities](https://www.reddit.com/r/socialmedia/)

## 🏷️ Issue Labels

We use these labels to organize issues:

- `bug` - Something isn't working
- `enhancement` - New feature request
- `new-ratio` - Request for new aspect ratio
- `documentation` - Improvements to docs
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention needed
- `platform-request` - New platform support

## 📐 Popular Ratio Requests

If you're looking to contribute, these are commonly requested ratios:
- **Pinterest**: 2:3 (portrait pins)
- **LinkedIn**: 1.91:1 (posts), 16:9 (articles)
- **Twitter**: 16:9 (posts), 2:1 (header)
- **Snapchat**: 9:16 (stories)
- **Print**: A4 (1:√2), Letter (8.5:11)

## 📄 License

By contributing to this project, you agree that your contributions will be licensed under the MIT License.

## 🙏 Recognition

Contributors will be recognized in the project README and release notes. Thank you for helping make content creation more efficient for photographers and creators worldwide!

---

Questions? Feel free to open an issue or start a discussion on GitHub!