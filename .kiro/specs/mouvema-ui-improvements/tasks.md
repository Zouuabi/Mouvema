# Implementation Plan

- [x] 1. Set up enhanced error handling foundation


  - Create comprehensive error models and enums for different error types
  - Implement error recovery service with retry logic and user feedback
  - Create reusable error display widgets (dialogs, snackbars, inline messages)
  - _Requirements: 6.1, 6.2, 6.4, 6.5_

- [x] 2. Enhance authentication system foundation



- [x] 2.1 Remove social login components and clean up authentication UI



  - Remove Facebook, Google, and Apple login buttons from login screen
  - Clean up unused social authentication logic in LoginCubit
  - Update login screen layout to focus on email/password authentication
  - _Requirements: 1.1, 1.7_

- [x] 2.2 Implement enhanced authentication error handling



  - Create AuthError model with specific error types (invalid email, wrong password, etc.)
  - Update LoginCubit and RegisterCubit to handle specific error scenarios
  - Add field-specific validation logic for email format and password strength
  - _Requirements: 1.2, 1.3, 1.4, 1.5_



- [x] 2.3 Create modern authentication UI components







  - Design new login screen with card-based layout and Material 3 styling
  - Create register screen with password strength indicator and real-time validation
  - Implement smooth loading states and success animations for authentication
  - _Requirements: 1.6, 1.7, 5.1, 5.2_

- [x] 2.4 Fix registration flow and Firebase integration




  - Remove phone number step from registration process (step 2 in current flow)
  - Update RegisterCubit to skip phone validation and storage
  - Fix Firebase integration to properly create accounts without phone number conflicts
  - Ensure RegisterTextField widget is completely independent from EnhancedTextField to avoid error handling conflicts
  - Update registration flow to only collect: user type, username, birth date, email, and password
  - Test Firebase account creation and profile storage without phone number requirement
  - _Requirements: 1.1.1, 1.1.2, 1.1.3, 1.1.4, 1.1.5, 1.1.6, 1.1.7_

- [ ] 3. Enhance geocoding and location services
- [ ] 3.1 Create enhanced geocoding service with caching and retry logic

  - Implement LocationData model with coordinates, address, and geocoding status
  - Create EnhancedGeocodingService with caching, retry policy, and error handling
  - Add search functionality using Nominatim API with autocomplete suggestions
  - _Requirements: 3.1, 3.2, 3.3, 3.4_

- [ ] 3.2 Improve location permission and GPS handling

  - Implement graceful location permission handling with user-friendly messages
  - Add fallback mechanisms for when GPS or geocoding fails
  - Create offline indicator and cached tile support for map functionality
  - _Requirements: 3.5, 3.6, 3.7_

- [ ] 4. Redesign post load screen with modern UI
- [ ] 4.1 Create new post load screen layout with card-based design

  - Implement modern card-based layout replacing the current bordered container
  - Create location selection card with origin/destination chips display
  - Add smooth animations and transitions for better user experience
  - _Requirements: 2.1, 2.2, 5.1, 5.3_

- [ ] 4.2 Enhance map selection interface and user interactions

  - Implement full-screen map with improved marker placement and removal
  - Add distinct marker colors (green for origin, red for destination) with animations
  - Create tap-to-remove functionality for existing markers with visual feedback
  - _Requirements: 2.3, 2.5, 2.6_

- [ ] 4.3 Integrate enhanced geocoding with post load workflow

  - Connect enhanced geocoding service to display location names in selection cards
  - Implement fallback to coordinates when geocoding fails with retry options
  - Add loading states and error handling for geocoding operations
  - _Requirements: 2.4, 2.7_

- [ ] 4.4 Improve form validation and submission experience

  - Implement comprehensive form validation with field-specific error highlighting
  - Add success feedback animations and smooth navigation after successful posting
  - Create consistent loading states throughout the posting workflow
  - _Requirements: 2.7, 2.8, 5.4, 5.5_

- [ ] 5. Modernize forgot password screens to match login design
- [x] 5.1 Update forgot password screen with modern login-style design






  - Replace current forgot password screen layout with login screen's design language
  - Use same background color, logo positioning, and typography as login screen
  - Apply consistent spacing, padding, and Material 3 styling throughout
  - Remove outdated option selection UI and simplify to direct email input
  - _Requirements: 6.1, 6.2, 6.3_

- [ ] 5.2 Modernize reset account screen with enhanced components

  - Replace MyTextField with EnhancedTextField component for consistency
  - Apply same card-based layout and visual hierarchy as login screen
  - Use LoadingButton component instead of basic ElevatedButton
  - Implement same error dialog styling and success feedback patterns
  - _Requirements: 6.3, 6.4, 6.5, 6.6, 6.7_

- [ ] 5.3 Integrate consistent navigation and user flow patterns

  - Ensure smooth transitions between forgot password screens match login flow
  - Apply same success animation and navigation patterns as login screen
  - Maintain consistent back navigation and screen transitions
  - _Requirements: 6.8_

