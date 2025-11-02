--[[----------------------------------------------------------------------------

Lightroom Ratio Creator - Main Plugin File

Creates virtual copies with different aspect ratios for social media, print,
and digital platforms. Provides an intuitive interface for content creators
and photographers to generate multiple formats efficiently.

Author: Wouter Vellekoop
License: MIT
Repository: https://github.com/woutervellekoop/lightroom-ratio-creator

------------------------------------------------------------------------------]]

-- Import Lightroom SDK modules
local LrApplication = import 'LrApplication'
local LrDialogs = import 'LrDialogs'
local LrTasks = import 'LrTasks'
local LrView = import 'LrView'
local LrBinding = import 'LrBinding'
local LrColor = import 'LrColor'
local LrLogger = import 'LrLogger'

-- Create logger for debugging
local logger = LrLogger('RatioCreator')
logger:enable("logfile")

-- Define popular aspect ratios with metadata
local ASPECT_RATIOS = {
    -- Social Media Ratios
    {
        id = "instagram_square",
        name = "Instagram Square",
        ratio = 1.0,
        category = "Social Media",
        platform = "Instagram",
        description = "Classic Instagram posts"
    },
    {
        id = "instagram_portrait", 
        name = "Instagram Portrait",
        ratio = 4/5,
        category = "Social Media", 
        platform = "Instagram",
        description = "Modern Instagram feed format"
    },
    {
        id = "instagram_story",
        name = "Instagram Story", 
        ratio = 9/16,
        category = "Social Media",
        platform = "Instagram",
        description = "Stories and Reels format"
    },
    {
        id = "tiktok",
        name = "TikTok",
        ratio = 9/16, 
        category = "Social Media",
        platform = "TikTok",
        description = "Vertical video format"
    },
    {
        id = "youtube",
        name = "YouTube",
        ratio = 16/9,
        category = "Social Media", 
        platform = "YouTube",
        description = "Landscape video format"
    },
    -- Print Ratios
    {
        id = "print_35mm",
        name = "35mm Film",
        ratio = 3/2,
        category = "Print",
        platform = "Print",
        description = "Standard DSLR format"
    },
    {
        id = "print_traditional",
        name = "Traditional",
        ratio = 4/3,
        category = "Print",
        platform = "Print", 
        description = "Classic camera format"
    },
    {
        id = "print_large_format",
        name = "Large Format",
        ratio = 5/4,
        category = "Print",
        platform = "Print",
        description = "Medium format cameras"
    }
}

-- Properties for the dialog
local props = LrBinding.makePropertyTable()

-- Initialize all ratio selections to false
for _, ratio in ipairs(ASPECT_RATIOS) do
    props[ratio.id] = false
end

-- Default settings
props.createCollections = true
props.smartOrientation = true
props.cropPosition = "center"

-- Function to create virtual copies with aspect ratios
local function createRatioVirtualCopies()
    LrTasks.startAsyncTask(function()
        local catalog = LrApplication.activeCatalog()
        local photos = catalog:getTargetPhotos()
        
        if #photos == 0 then
            LrDialogs.message("No Photos Selected", 
                             "Please select one or more photos and try again.", 
                             "info")
            return
        end
        
        -- Collect selected ratios
        local selectedRatios = {}
        for _, ratio in ipairs(ASPECT_RATIOS) do
            if props[ratio.id] then
                table.insert(selectedRatios, ratio)
            end
        end
        
        if #selectedRatios == 0 then
            LrDialogs.message("No Ratios Selected", 
                             "Please select at least one aspect ratio and try again.", 
                             "info")
            return
        end
        
        -- Process photos
        local progressScope = LrDialogs.showModalProgressDialog({
            title = "Creating Ratio Virtual Copies",
            functionContext = catalog,
        })
        
        catalog:withWriteAccessDo("Create Ratio Virtual Copies", function()
            local totalOperations = #photos * #selectedRatios
            local currentOperation = 0
            
            for _, photo in ipairs(photos) do
                if progressScope:isCanceled() then break end
                
                for _, ratio in ipairs(selectedRatios) do
                    currentOperation = currentOperation + 1
                    
                    progressScope:setPortionComplete(currentOperation, totalOperations)
                    progressScope:setCaption(string.format("Creating %s copy of photo %d/%d", 
                                           ratio.name, currentOperation, totalOperations))
                    
                    -- Create virtual copy
                    local virtualCopy = photo:createVirtualCopy()
                    if virtualCopy then
                        -- Set crop for the aspect ratio
                        local cropRatio = ratio.ratio
                        
                        -- Adjust ratio based on image orientation if smart orientation is enabled
                        if props.smartOrientation then
                            local metadata = photo:getFormattedMetadata()
                            local orientation = metadata.orientation or "landscape"
                            
                            -- For portrait images, invert certain ratios
                            if orientation == "portrait" and cropRatio > 1.0 then
                                cropRatio = 1.0 / cropRatio
                            elseif orientation == "landscape" and cropRatio < 1.0 then
                                cropRatio = 1.0 / cropRatio  
                            end
                        end
                        
                        -- Apply crop with centered positioning
                        local cropSettings = {
                            CropConstrainToWarp = false,
                            CropBottom = 1.0,
                            CropTop = 0.0,
                            CropLeft = 0.0, 
                            CropRight = 1.0,
                            HasCrop = true,
                            CropAngle = 0,
                            AspectRatio = cropRatio
                        }
                        
                        virtualCopy:applyDevelopSettings(cropSettings)
                        
                        -- Set title to include ratio information
                        local title = string.format("%s - %s", 
                                    photo:getFormattedMetadata("fileName"), 
                                    ratio.name)
                        virtualCopy:setPropertyForPlugin(_PLUGIN, "ratioType", ratio.name)
                        
                        logger:info(string.format("Created %s virtual copy for %s", 
                                  ratio.name, photo:getFormattedMetadata("fileName")))
                    else
                        logger:error(string.format("Failed to create virtual copy for %s", 
                                   photo:getFormattedMetadata("fileName")))
                    end
                end
            end
        end)
        
        progressScope:done()
        
        LrDialogs.message("Complete!", 
                         string.format("Successfully created %d virtual copies with selected aspect ratios.", 
                                     currentOperation), 
                         "info")
    end)
end

-- Create the dialog interface
local function showRatioCreatorDialog()
    local f = LrView.osFactory()
    
    -- Create ratio checkboxes organized by category
    local socialMediaSection = f:group_box {
        title = "Social Media Ratios",
        f:column {
            spacing = f:control_spacing(),
        }
    }
    
    local printSection = f:group_box {
        title = "Print Ratios", 
        f:column {
            spacing = f:control_spacing(),
        }
    }
    
    -- Add social media checkboxes
    for _, ratio in ipairs(ASPECT_RATIOS) do
        if ratio.category == "Social Media" then
            local checkbox = f:checkbox {
                title = string.format("%s (%s)", ratio.name, ratio.description),
                value = LrView.bind(ratio.id),
                tooltip = string.format("Create %s copies for %s", ratio.name, ratio.platform)
            }
            socialMediaSection:add_row(checkbox)
        end
    end
    
    -- Add print checkboxes
    for _, ratio in ipairs(ASPECT_RATIOS) do
        if ratio.category == "Print" then
            local checkbox = f:checkbox {
                title = string.format("%s (%s)", ratio.name, ratio.description),
                value = LrView.bind(ratio.id),
                tooltip = string.format("Create %s format copies", ratio.name)
            }
            printSection:add_row(checkbox)
        end
    end
    
    -- Options section
    local optionsSection = f:group_box {
        title = "Options",
        f:column {
            spacing = f:control_spacing(),
            
            f:checkbox {
                title = "Smart Orientation",
                value = LrView.bind('smartOrientation'),
                tooltip = "Automatically adjust ratios based on image orientation"
            },
            
            f:checkbox {
                title = "Create Collections",
                value = LrView.bind('createCollections'), 
                tooltip = "Organize virtual copies in collections by ratio type"
            },
        }
    }
    
    -- Main dialog content
    local contents = f:column {
        spacing = f:dialog_spacing(),
        
        f:static_text {
            title = "Select the aspect ratios you want to create as virtual copies:",
            font = "<system/bold>"
        },
        
        socialMediaSection,
        printSection, 
        optionsSection,
    }
    
    -- Show dialog
    local result = LrDialogs.presentModalDialog {
        title = "Ratio Creator",
        contents = contents,
        actionBinding = {
            enabled = true,
        },
        accessoryView = f:push_button {
            title = "Create Virtual Copies",
            action = function()
                createRatioVirtualCopies()
            end
        }
    }
end

-- Main entry point
showRatioCreatorDialog()