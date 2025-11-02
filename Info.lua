--[[----------------------------------------------------------------------------

Crop & Roll Ratio Creator - Open Source Plugin

A Lightroom Classic plugin that creates virtual copies with different aspect 
ratios, perfect for social media content creators, photographers, and designers
who need multiple formats from a single image.

Author: Wouter Vellekoop
Version: 1.0.0
License: MIT
Repository: https://github.com/woutervellekooppixel/lightroom-ratio-creator

Features:
- Popular aspect ratios (Instagram, TikTok, YouTube, Print)
- Smart orientation detection
- Automatic centered cropping
- Collection management
- Quick presets for social media and print

------------------------------------------------------------------------------]]

return {
	-- Plugin identification
	LrSdkVersion = 11.0,
	LrSdkMinimumVersion = 10.0,
	
	-- Plugin metadata
	LrToolkitIdentifier = 'com.cropandroll.lightroom.ratiocreator',
	LrPluginName = 'Crop & Roll Ratio Creator',
	
	-- Version information
	VERSION = { major = 1, minor = 0, revision = 0, build = 20251102 },
	
	-- Library menu integration
	LrLibraryMenuItems = {
		{
			title = "Crop & Roll Ratio Creator",
			file = "CreateRatioCopies.lua",
		},
	},
	
	-- Plugin info
	LrPluginInfoUrl = 'https://github.com/woutervellekooppixel/lightroom-ratio-creator',
	
	-- Plugin metadata
	LrPluginInfo = {
		title = "Crop & Roll Ratio Creator",
		summary = "Create virtual copies with different aspect ratios",
		description = "An open source plugin that creates virtual copies with popular aspect ratios for social media, print, and digital platforms. Perfect for content creators and photographers.",
		author = "Wouter Vellekoop",
		version = "1.0.0",
		license = "MIT",
		homepage = "https://github.com/woutervellekoop/lightroom-ratio-creator"
	},
}