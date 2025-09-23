# Fabrica - AI-Powered 3D Printing Assistant

## Overview

**Fabrica** is an iOS application built with SwiftUI that serves as an intelligent 3D printing companion. The app leverages AI technology to analyze 3D printing materials, objects, and print quality through image recognition, providing users with expert recommendations and technical insights for optimal 3D printing results.

## Key Features

### 🤖 AI-Powered Analysis
- **OpenAI GPT-4 Vision Integration**: Advanced image analysis using OpenAI's GPT-4 vision model
- **Material Identification**: Automatically detects filament types (PLA, ABS, PETG, TPU, PC, Nylon, etc.)
- **Print Quality Assessment**: Analyzes layer adhesion, surface finish, dimensional accuracy, and defects
- **Technical Recommendations**: Provides optimal print settings, temperatures, speeds, and post-processing steps

### 📱 Image Capture & Analysis
- **Camera Integration**: Take photos directly within the app for real-time analysis
- **Photo Library Support**: Import existing images from the device's photo library
- **Visual Object Detection**: Overlay bounding boxes on detected objects and materials
- **Local Vision Fallback**: Uses iOS Vision framework when OpenAI API is unavailable

### 🖨️ Printer Management
- **Multi-Printer Support**: Configure multiple 3D printers (A1, A1 mini, P1P, P1S, X1, X1 Carbon, H2, H2D)
- **Material Selection**: Choose from various printing materials with specific settings
- **Print Settings Configuration**: Detailed settings for quality, strength, speed, support, and more

### 📊 Comprehensive Settings
- Quality control parameters
- Strength and speed configurations
- Support structure settings
- Layer height and infill density
- Retraction settings (distance, speed, count)
- Advanced features (coasting, wiping)

## Technical Architecture

### Core Components

#### `HomeView.swift` (470 lines)
- Main user interface with form-based layout
- Image display with object detection overlays
- Printer and material selection interface
- AI analysis results display with copy/share functionality

#### `ThreeDPrintingClassifier.swift` (363 lines)
- Core AI classification engine
- OpenAI API integration for advanced image analysis
- Local Vision framework fallback
- Comprehensive prompt engineering for 3D printing expertise
- Error handling and network management

#### `CameraView.swift` (61 lines)
- UIImagePickerController wrapper for camera functionality
- Seamless integration with the main analysis workflow

#### `Models.swift` (22 lines)
- `DetectedObject` structure for object detection results
- Includes confidence scores and bounding box coordinates

#### `APIConfig.swift` (39 lines)
- OpenAI API configuration and key management
- Environment variable support for secure API key storage
- Rate limiting and error message definitions

#### `Settings.swift` (54 lines)
- Print settings data model
- Comprehensive parameters for 3D printing optimization

### Data Models

```swift
struct DetectedObject: Identifiable {
    let id = UUID()
    let name: String
    let confidence: Double
    let boundingBox: CGRect
}

class Settings: Decodable, Identifiable {
    var quality: String
    var strength: String
    var speed: Int
    var support: String
    // ... additional printing parameters
}
```

## AI Integration Details

### OpenAI GPT-4 Vision Analysis
The app sends images to OpenAI's GPT-4 vision model with a comprehensive prompt that requests:

1. **Material Identification**
   - Specific filament/resin type detection
   - Surface finish and texture analysis
   - Material property assessment

2. **Print Quality Assessment**
   - Layer adhesion evaluation
   - Surface finish quality analysis
   - Defect identification (stringing, warping, etc.)

3. **Technical Recommendations**
   - Optimal print settings (temperatures, speeds)
   - Infill and support suggestions
   - Post-processing recommendations

4. **Professional Insights**
   - Application suitability analysis
   - Improvement suggestions
   - Safety and cost considerations

### Fallback Mechanisms
- Local iOS Vision framework for basic object detection
- Graceful degradation when API is unavailable
- Comprehensive error handling and user feedback

## User Interface

### Main Features
- **Clean, Form-Based Design**: Organized sections for easy navigation
- **Real-Time Analysis Feedback**: Progress indicators and status updates
- **Visual Object Detection**: Overlay rectangles on detected objects
- **Comprehensive Results Display**: Structured AI analysis with copy/share options
- **Printer Configuration**: Modal sheets for printer and material selection

### User Experience
- Intuitive camera and photo picker integration
- Real-time analysis status with loading indicators
- Error handling with actionable feedback
- Professional-grade analysis results presentation

## Installation & Setup

### Prerequisites
- iOS device with camera capability
- Xcode 15+ for development
- OpenAI API key for full functionality

### Configuration
1. Add OpenAI API key to `APIConfig.swift` or set as environment variable
2. Build and run the project in Xcode
3. Grant camera and photo library permissions when prompted

## Technical Specifications

- **Platform**: iOS (SwiftUI)
- **Minimum iOS Version**: iOS 14+
- **Architecture**: MVVM with ObservableObject
- **AI Integration**: OpenAI GPT-4 Vision API
- **Local Processing**: iOS Vision Framework
- **Image Processing**: Core Graphics and UIKit

## Future Enhancements

- Cloud-based print settings synchronization
- Expanded printer database
- Material property database integration
- Advanced print failure prediction
- Community sharing features
- Offline AI model integration

## Development Notes

- Created by Mason Wyper (August 2025)
- Active development with regular updates
- Comprehensive error handling and user feedback
- Modular architecture for easy extension
- Professional-grade AI prompt engineering

## File Structure

```
Fabrica/
├── Fabrica/
│   ├── FabricaApp.swift          # App entry point
│   ├── ContentView.swift         # Tab view container
│   ├── HomeView.swift           # Main interface (470 lines)
│   ├── CameraView.swift         # Camera integration
│   ├── ThreeDPrintingClassifier.swift  # AI engine (363 lines)
│   ├── Models.swift             # Data models
│   ├── Settings.swift           # Print settings
│   ├── APIConfig.swift          # API configuration
│   └── Assets.xcassets/         # App assets
├── FabricaTests/                # Unit tests
├── FabricaUITests/              # UI tests
└── Fabrica.xcodeproj/           # Xcode project
```

---

**Fabrica** represents a cutting-edge approach to 3D printing assistance, combining advanced AI analysis with intuitive mobile interface design to help users achieve optimal printing results.
