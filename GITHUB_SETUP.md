# GitHub Setup Guide for FontBlitz

Follow these steps to upload FontBlitz to your GitHub account.

## Prerequisites
- GitHub account (create one at github.com if needed)
- Git installed on your Windows machine ([download here](https://git-scm.com/download/win))

## Step-by-Step Upload

### Method 1: GitHub Desktop (Easiest)

1. **Download GitHub Desktop**
   - Go to https://desktop.github.com/
   - Install and sign in with your GitHub account

2. **Create New Repository**
   - Click "File" → "New Repository"
   - Name: `FontBlitz`
   - Description: `⚡ Batch font installer for Windows - intelligently extracts and installs fonts from ZIP archives`
   - Local Path: Point to your FontBlitz folder
   - Check "Initialize this repository with a README" = NO (we already have one)
   - Click "Create Repository"

3. **Publish to GitHub**
   - Click "Publish repository"
   - Uncheck "Keep this code private" (unless you want it private)
   - Click "Publish Repository"

Done! Your repository is now live at `github.com/YourUsername/FontBlitz`

### Method 2: Command Line (For Git Users)

```bash
# Navigate to your FontBlitz folder
cd C:\path\to\FontBlitz

# Initialize git repository
git init

# Add all files
git add .

# Create first commit
git commit -m "Initial release of FontBlitz v1.0.0"

# Create repository on GitHub first (via website), then:
git remote add origin https://github.com/YourUsername/FontBlitz.git

# Push to GitHub
git branch -M main
git push -u origin main
```

### Method 3: GitHub Web Interface (Drag & Drop)

1. Go to github.com and click "New repository"
2. Name it `FontBlitz`
3. Add description: `⚡ Batch font installer for Windows - intelligently extracts and installs fonts from ZIP archives`
4. Set to Public
5. Do NOT initialize with README
6. Click "Create repository"
7. Click "uploading an existing file"
8. Drag and drop all FontBlitz files
9. Commit directly to main branch

## After Upload

### Set Repository Topics
Add these topics to your repository for discoverability:
- `powershell`
- `windows`
- `fonts`
- `batch-installer`
- `font-management`
- `creative-tools`
- `design-tools`
- `typography`

### Create a Release
1. Go to your repository page
2. Click "Releases" → "Create a new release"
3. Tag version: `v1.0.0`
4. Release title: `FontBlitz v1.0.0 - Initial Release`
5. Description: Copy from CHANGELOG.md
6. Attach `FontBlitz.ps1` as a binary
7. Click "Publish release"

### Repository Settings (Optional)
- **About Section**: Add description and website (sagemolotov.com)
- **Topics**: Add the tags listed above
- **Social Preview**: Upload a custom image if you have one

## Updating the Repository Later

When you make changes:

**GitHub Desktop:**
1. Make your changes to files
2. GitHub Desktop will show changes automatically
3. Write a commit message
4. Click "Commit to main"
5. Click "Push origin"

**Command Line:**
```bash
git add .
git commit -m "Description of changes"
git push
```

## Repository URL
After setup, your repository will be at:
```
https://github.com/SageMolotov/FontBlitz
```

Update this URL in your README badges if different.
