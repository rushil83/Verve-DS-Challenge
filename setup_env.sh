#!/bin/bash

# Create a Python virtual environment
echo "Creating Python virtual environment..."
python3 -m venv jupyter_env

# Activate the virtual environment
echo "Activating virtual environment..."
source jupyter_env/bin/activate

# Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip

# Install required Python packages
echo "Installing required packages..."
pip install pandas numpy matplotlib xgboost scikit-learn jupyter

# Notify user of successful setup
echo "Environment setup complete. To start Jupyter Notebook, activate the environment and run 'jupyter notebook'."