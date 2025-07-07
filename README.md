# Submission Using Shiny

This project provides a Shiny application for automated performance metric calculation in clinical evaluations of in vitro diagnostic (IVD) medical devices. The app is containerized using Docker for easy deployment.

---

## 🚀 How to Run the Shiny App Using Docker

### 1. ✅ Verify Docker Installation

After installing [Docker Desktop](https://www.docker.com/products/docker-desktop/), open a terminal and run the following command to check if Docker is working:

```bash
docker --version
```

You should see the installed Docker version

### 2. 📂 Clone the Repository and Move into the Directory

Use the following commands to clone the repository and move into the project folder:

```bash
git clone https://github.com/Youngho-Cha/submission-using-shiny.git
cd submission-using-shiny
```

This will download the source code and set your working directory to the project folder.

### 3. 🛠️ Build the Docker Image

Build the Docker image using the following command:

```bash
docker build --no-cache -t submission-app .
```

### 4. 🧱 Run the Shiny App Inside the Docker Container

Launch the Shiny app by running:

```bash
docker run -p 3838:3838 submission-app
```

This command runs the app inside a container and maps port 3838 to your local machine.

### 5. 🌐 Access the Shiny App in Your Browser

After the container starts, open your browser and visit:

```arduino
http://localhost:3838
```

You should see the Shiny app running and ready to use.

---

## 📝 How to Use the Shiny App

### 1. Upload CSV File

Upload the dataset to be analyzed.  
> ⚠️ Only `.csv` files are accepted.

· · · · · · · · · ·

#### 1.1 Select Actual Variable  
Select the variable that represents the **true class (actual condition)** of the patient.

##### 1.1.1 Which value is POSITIVE for Actual?  
Among the values of the variable selected in 1.1, choose the one that represents **positive (1)**.

· · · · · · · · · ·

#### 1.2 Select Predicted Variable  
Select the variable that represents the **predicted condition** of the patient.

##### 1.2.1 Which value is POSITIVE for Predicted?  
Among the values of the variable selected in 1.2, choose the one that represents **positive (1)**.

· · · · · · · · · ·

#### 1.3 Select Score Variable (optional)  
Select the variable that represents **prediction score (e.g., probability)**.  
This is optional — set it to `None` if you don’t want to calculate AUC or if the data doesn’t contain score variables.

· · · · · · · · · ·

### 2. Select Metrics to Calculate  
Choose the performance metrics to compute.

· · · · · · · · · ·

### 3. Binary CI Method  
Choose the method to calculate **confidence intervals** for binary metrics such as sensitivity, specificity, PPV, NPV, and accuracy.

· · · · · · · · · ·

### 4. AUC CI Method  
Choose the method to calculate the **confidence interval** for AUC.

· · · · · · · · · ·

### 5. Significance Level (α)  
Select the significance level to compute **100(1−α)% confidence intervals**.

· · · · · · · · · ·

### 6. Bootstrap Iterations  
If AUC is to be calculated and the CI method is set to `"bootstrap"`, specify the number of bootstrap samples.

· · · · · · · · · ·

### 7. Decimal Places for Results  
Choose the number of decimal places to display in the output results.

· · · · · · · · · ·

### 📤 Saving the Report

As you select or change each setting, the results will automatically be updated in the right-hand panel.  
To save the result table, click the **"Download Report"** button on the bottom left.

> 📁 The report will be saved to the `/reports` directory with the filename format:  
> `performance_report_YYYYMMDD_hhmm.csv`
