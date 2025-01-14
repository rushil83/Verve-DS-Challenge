# Jupyter Notebook Environment Setup

This repository contains a bash script to set up a Python environment with all the necessary dependencies for running a Jupyter Notebook.

## Steps to Set Up and Run

1. **Ensure Python 3 is installed**:
   - Verify Python 3 is installed on your system by running:
     ```bash
     python3 --version
     ```
   - If not installed, download and install Python 3 from [python.org](https://www.python.org/).

2. **Run the setup script**:
   - Open a terminal and navigate to the directory containing the `setup_env.sh` file.
   - Make the script executable:
     ```bash
     chmod +x setup_env.sh
     ```
   - Run the script:
     ```bash
     ./setup_env.sh
     ```

3. **Activate the virtual environment**:
   - After the script completes, activate the virtual environment:
     - **On Linux/macOS**:
       ```bash
       source jupyter_env/bin/activate
       ```
     - **On Windows (Command Prompt)**:
       ```cmd
       jupyter_env\Scripts\activate
       ```
     - **On Windows (PowerShell)**:
       ```powershell
       .\jupyter_env\Scripts\Activate.ps1
       ```

4. **Start Jupyter Notebook**:
   - Launch Jupyter Notebook:
     ```bash
     jupyter notebook
     ```
   - Open your desired notebook file and start working.

5. **Deactivate the environment**:
   - When you're done, deactivate the virtual environment:
     ```bash
     deactivate
     ```

## Notes
- The script installs the following Python packages:
  - `pandas`
  - `numpy`
  - `matplotlib`
  - `xgboost`
  - `scikit-learn`
  - `jupyter`
- Ensure you have sufficient permissions to execute the script and install packages.
