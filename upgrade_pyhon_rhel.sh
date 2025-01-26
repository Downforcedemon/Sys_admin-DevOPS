# Step 1: Install required development tools and dependencies for building Python
sudo dnf groupinstall "Development Tools" -y  # Install GCC, make, and related tools
sudo dnf install gcc gcc-c++ make wget bzip2 zlib-devel xz-devel libffi-devel -y  # Required dependencies

# Step 2: Download the latest Python source code
cd /usr/src  # Move to the source directory
sudo wget https://www.python.org/ftp/python/3.12.8/Python-3.12.8.tgz  # Download the Python 3.12.8 tarball

# Step 3: Extract the tarball
sudo tar xzf Python-3.12.8.tgz  # Extract the tarball
cd Python-3.12.8  # Move into the extracted directory

# Step 4: Configure, build, and install Python
sudo ./configure --enable-optimizations  # Configure the build with optimizations
sudo make  # Build the source code
sudo make install  # Install Python (this replaces the system Python if necessary)

# Problem Faced: The default 'python3' command still pointed to the old Python version (3.9.21).
# Resolution: Remove the old symbolic link and create a new one pointing to the newly installed Python version.

# Step 5: Update the symbolic link for Python
sudo rm -f /usr/bin/python3  # Remove the old symlink or file
sudo ln -s /usr/local/bin/python3.12 /usr/bin/python3  # Create a new symlink to Python 3.12

# Step 6: Verify the installed version
python3 --version  # Check that the default Python version is now Python 3.12.8

# Problem Faced: A typo in removing the previous symlink caused errors.
# Resolution: Ensure proper commands were used to remove old files and symlinks.

# Clean up unnecessary files or incorrect symlinks
sudo rm -f /usr/bin/pyhon3  # Fix typos in removing symlinks
sudo rm -f /usr/bin/py  # Remove any incomplete or unnecessary symlinks

# Step 7: Test system tools to ensure compatibility
dnf --version  # Test that system tools relying on Python are still functional

# Step 8: Optional - Add Python 3.12 to PATH for all users (if not already accessible globally)
echo "export PATH=/usr/local/bin:$PATH" >> ~/.bashrc  # Add /usr/local/bin to PATH
source ~/.bashrc  # Reload shell configuration

# Step 9: Optional - Use 'alternatives' to manage multiple Python versions
sudo alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.12 1  # Add Python 3.12 to alternatives
sudo alternatives --config python3  # Set Python 3.12 as the default version

# Verify again to ensure everything works as expected
python3 --version  # Should display Python 3.12.8

------------------------------------------------------------------------------------------------------------------------
#!/bin/bash

# Shell script to install Python 3.12.8 on RHEL 9.4

set -e  # Exit immediately if a command exits with a non-zero status

echo "Starting Python 3.12.8 installation..."

# Step 1: Install development tools and dependencies
echo "Installing development tools and required dependencies..."
sudo dnf groupinstall "Development Tools" -y
sudo dnf install -y gcc gcc-c++ make wget bzip2 zlib-devel xz-devel libffi-devel

# Step 2: Download the Python 3.12.8 source code
PYTHON_VERSION="3.12.8"
PYTHON_TARBALL="Python-${PYTHON_VERSION}.tgz"
PYTHON_SOURCE_DIR="/usr/src/Python-${PYTHON_VERSION}"

echo "Downloading Python ${PYTHON_VERSION} source code..."
cd /usr/src
sudo wget "https://www.python.org/ftp/python/${PYTHON_VERSION}/${PYTHON_TARBALL}"

# Step 3: Extract the tarball
echo "Extracting Python source code..."
sudo tar xzf "${PYTHON_TARBALL}"

# Step 4: Configure, build, and install Python
echo "Building and installing Python ${PYTHON_VERSION}..."
cd "${PYTHON_SOURCE_DIR}"
sudo ./configure --enable-optimizations
sudo make
sudo make install

# Step 5: Update the default Python version
echo "Updating default Python version to ${PYTHON_VERSION}..."
if [[ -L /usr/bin/python3 ]]; then
    sudo rm -f /usr/bin/python3
fi
sudo ln -s /usr/local/bin/python3.12 /usr/bin/python3

# Step 6: Verify the installation
echo "Verifying Python installation..."
if python3 --version | grep -q "${PYTHON_VERSION}"; then
    echo "Python ${PYTHON_VERSION} successfully installed and set as the default version."
else
    echo "Python installation failed. Please check the logs."
    exit 1
fi

# Step 7: Test system tools
echo "Testing system tools for compatibility..."
if ! dnf --version >/dev/null 2>&1; then
    echo "Warning: System tools might not be compatible with Python ${PYTHON_VERSION}. Reverting to the original Python version..."
    sudo ln -s /usr/bin/python3.9 /usr/bin/python3
    echo "Default Python reverted to 3.9 for system compatibility."
else
    echo "System tools are compatible with Python ${PYTHON_VERSION}."
fi

# Step 8: Clean up
echo "Cleaning up installation files..."
cd /usr/src
sudo rm -rf "${PYTHON_SOURCE_DIR}" "${PYTHON_TARBALL}"

echo "Python ${PYTHON_VERSION} installation process completed successfully."
