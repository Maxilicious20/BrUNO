# BrUNO - Production Setup Guide

## Issues Fixed

### 1. ✅ Tailwind CSS CDN (Production Warning)
**Issue**: Using `cdn.tailwindcss.com` in production is not recommended by Tailwind CSS.

**Solution**: Use Tailwind CLI for production builds.

#### Setup Instructions:

```bash
# Install Tailwind CSS and dependencies
npm install -D tailwindcss postcss autoprefixer

# Initialize Tailwind configuration
npx tailwindcss init -p

# This creates:
# - tailwind.config.js
# - postcss.config.js
```

#### Update your `index.html`:
```html
<!-- Remove this: -->
<!-- <script src="https://cdn.tailwindcss.com"></script> -->

<!-- Add this instead: -->
<link rel="stylesheet" href="./output.css">
```

#### Build CSS:
```bash
# Development (watch mode)
npx tailwindcss -i ./src/input.css -o ./output.css --watch

# Production (minified)
npx tailwindcss -i ./src/input.css -o ./output.css --minify
```

---

### 2. ✅ Firebase Invalid API Key Error
**Issue**: Firebase API key was empty string, causing `auth/invalid-api-key` error.

**Solution**: Use environment variables for sensitive Firebase configuration.

#### Setup Instructions:

1. **Create `.env` file in your project root:**
```bash
REACT_APP_FIREBASE_API_KEY=your_api_key_here
REACT_APP_FIREBASE_AUTH_DOMAIN=your-project.firebaseapp.com
REACT_APP_FIREBASE_PROJECT_ID=your-project-id
REACT_APP_FIREBASE_STORAGE_BUCKET=your-project.appspot.com
REACT_APP_FIREBASE_MESSAGING_SENDER_ID=your-sender-id
REACT_APP_FIREBASE_APP_ID=your-app-id
```

2. **Get your Firebase credentials:**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Select your project
   - Click ⚙️ Settings → Project settings
   - Copy the Web config

3. **For Vercel deployment:**
   - Go to your Vercel project settings
   - Add these environment variables in "Environment Variables"
   - Ensure they're added to Production, Preview, and Development

4. **For other platforms:**
   - Add the `.env` file to your deployment configuration
   - Never commit `.env` to version control (add to `.gitignore`)

---

### 3. ✅ Dialog Accessibility Warnings
**Issue**: Dialog modals missing `role="dialog"`, `aria-modal="true"`, and proper heading/description associations.

**Solutions Applied**:
- Added `role="alertdialog"` and `role="dialog"` to modal elements
- Added `aria-modal="true"` for proper accessibility
- Added `aria-labelledby` and `aria-describedby` attributes
- Used semantic `<h2>` instead of `<h3>` for main titles
- Added `aria-label` attributes to color selection buttons

---

### 4. ⚠️ Zustand Deprecation Warning
**If you're using Zustand** (state management library):

```javascript
// ❌ Deprecated
import create from 'zustand'

// ✅ Correct
import { create } from 'zustand'
```

This warning appears if you have a React component using the old Zustand API.

---

## Deployment Checklist

- [ ] Firebase environment variables are configured
- [ ] Tailwind CSS is built and minified for production
- [ ] `.env` file is added to `.gitignore`
- [ ] All modals have proper ARIA attributes
- [ ] No console warnings in browser DevTools
- [ ] Test with screen readers (NVDA, JAWS, VoiceOver)

## Production Build Command

```bash
# Build Tailwind CSS
npx tailwindcss -i ./src/input.css -o ./output.css --minify

# Your deployment platform should then serve the built HTML with the minified CSS
```

## Additional Resources

- [Tailwind CSS Production Guide](https://tailwindcss.com/docs/installation)
- [Firebase Web Setup](https://firebase.google.com/docs/web/setup)
- [Web Accessibility - ARIA Dialogs](https://www.w3.org/WAI/ARIA/apg/patterns/dialogmodal/)
- [Zustand Migration Guide](https://github.com/pmndrs/zustand)
