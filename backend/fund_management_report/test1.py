# from flask import Flask, request, jsonify
# import pandas as pd
# from sklearn.model_selection import train_test_split
# from sklearn.tree import DecisionTreeClassifier
# from sklearn.metrics import accuracy_score
# from reportlab.lib.pagesizes import letter
# from reportlab.pdfgen import canvas
# from reportlab.lib import colors
# from reportlab.lib.units import inch
# from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Image
# from reportlab.lib.styles import getSampleStyleSheet
# from openai import OpenAI
# import matplotlib.pyplot as plt
# import seaborn as sns

# app = Flask(__name__)

# # Initialize the NVIDIA NeMo API client
# client = OpenAI(
#     base_url="https://integrate.api.nvidia.com/v1",
#     # api_key="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"
# )

# # Function to generate roadmap using the NVIDIA NeMo API
# def generate_roadmap(company_info):
#     prompt = (f"Generate a roadmap for {company_info['company_name']} in the {company_info['industry']} industry "
#               f"at the {company_info['funding_stage']} stage with business goals of {company_info['business_goals']}.")
#     completion = client.chat.completions.create(
#         model="nvidia/llama-3.1-nemotron-70b-instruct",
#         messages=[{"role": "user", "content": prompt}],
#         temperature=0.5,
#         top_p=1,
#         max_tokens=1024,
#         stream=True
#     )

#     roadmap_text = ""
#     for chunk in completion:
#         if chunk.choices[0].delta.content is not None:
#             roadmap_text += chunk.choices[0].delta.content
#     return roadmap_text

# # Load data from a CSV file
# # Replace 'data.csv' with the path to your CSV file
# df = pd.read_csv('V:/OneDrive/Desktop/StateNightOwl/Testing_Models/smedata.csv')

# # Features and target
# X = df[['revenue_growth', 'profit_margin', 'market_size', 'credit_risk', 'investor_preference']]
# y = df['suitable_investment']

# # Split the data
# X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# # Train a DecisionTree model
# model = DecisionTreeClassifier(random_state=42)
# model.fit(X_train, y_train)

# # Make predictions
# y_pred = model.predict(X_test)

# # Evaluate the model
# accuracy = accuracy_score(y_test, y_pred)
# print(f'Accuracy: {accuracy}')

# # Generate suggestions for a new investor profile
# # Replace these values with dynamic input if needed
# new_investor = pd.DataFrame({
#     'revenue_growth': [0.22],
#     'profit_margin': [0.085],
#     'market_size': [1600],
#     'credit_risk': [0.032],
#     'investor_preference': [2]  # 2: Low risk
# })

# suggestion = model.predict(new_investor)
# print(f'Suggestion: {"Suitable" if suggestion[0] == 1 else "Not Suitable"}')

# # Example company information
# company_info = {
#     'company_name': 'TechInnovate Solutions',
#     'industry': 'FinTech',
#     'funding_stage': 'Series A',
#     'business_goals': 'Growth, Scaling, Product Development'
# }

# # Generate dynamic roadmap using the NVIDIA NeMo API
# roadmap_text = generate_roadmap(company_info)

# # Generate graphs
# def generate_graphs(df):
#     # Plot 1: Distribution of Revenue Growth
#     plt.figure(figsize=(10, 6))
#     sns.histplot(df['revenue_growth'], kde=True)
#     plt.title('Distribution of Revenue Growth')
#     plt.xlabel('Revenue Growth')
#     plt.ylabel('Frequency')
#     plt.savefig('revenue_growth_distribution.png')
#     plt.close()

#     # Plot 2: Correlation Heatmap
#     plt.figure(figsize=(10, 6))
#     sns.heatmap(df.corr(), annot=True, cmap='coolwarm')
#     plt.title('Correlation Heatmap')
#     plt.savefig('correlation_heatmap.png')
#     plt.close()

#     # Plot 3: Boxplot of Market Size by Suitable Investment
#     plt.figure(figsize=(10, 6))
#     sns.boxplot(x='suitable_investment', y='market_size', data=df)
#     plt.title('Market Size by Suitable Investment')
#     plt.xlabel('Suitable Investment')
#     plt.ylabel('Market Size')
#     plt.savefig('market_size_boxplot.png')
#     plt.close()

# # Generate the graphs
# generate_graphs(df)

# # Function to generate PDF report
# def generate_pdf_report(suggestion, company_info, roadmap_text):
#     # Create a PDF document
#     doc = SimpleDocTemplate("funding_roadmap.pdf", pagesize=letter)
#     elements = []

#     # Styles
#     styles = getSampleStyleSheet()
#     title_style = styles['Title']
#     heading_style = styles['Heading2']
#     normal_style = styles['Normal']

#     # Title
#     elements.append(Paragraph("Funding Roadmap Report", title_style))

#     # Model Accuracy
#     elements.append(Paragraph(f"Model Accuracy: {accuracy:.2f}", normal_style))

#     # Investment Suggestion
#     elements.append(Paragraph(f"Investment Suggestion: {'Suitable' if suggestion[0] == 1 else 'Not Suitable'}", normal_style))

#     # Company Information
#     elements.append(Paragraph(f"Company Name: {company_info['company_name']}", heading_style))
#     elements.append(Paragraph(f"Industry: {company_info['industry']}", normal_style))
#     elements.append(Paragraph(f"Funding Stage: {company_info['funding_stage']}", normal_style))
#     elements.append(Paragraph(f"Business Goals: {company_info['business_goals']}", normal_style))

#     # Detailed Activity Breakdown
#     elements.append(Paragraph("Detailed Activity Breakdown", heading_style))

#     # Split the roadmap text into sections
#     roadmap_sections = roadmap_text.split('\n\n')
#     for section in roadmap_sections:
#         elements.append(Paragraph(section, normal_style))

#     # Add graphs
#     elements.append(Paragraph("Graphs", heading_style))
#     elements.append(Image('revenue_growth_distribution.png', width=4*inch, height=3*inch))
#     elements.append(Image('correlation_heatmap.png', width=4*inch, height=3*inch))
#     elements.append(Image('market_size_boxplot.png', width=4*inch, height=3*inch))

#     # Build the PDF
#     doc.build(elements)

# # Generate the PDF report
# generate_pdf_report(suggestion, company_info, roadmap_text)


from flask import Flask, request, jsonify
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
from reportlab.lib import colors
from reportlab.lib.units import inch
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Image
from reportlab.lib.styles import getSampleStyleSheet
from openai import OpenAI
import matplotlib.pyplot as plt
import seaborn as sns

app = Flask(__name__)

# Initialize the NVIDIA NeMo API client
client = OpenAI(
    base_url="https://integrate.api.nvidia.com/v1",
    # api_key="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"
)

# Function to generate roadmap using the NVIDIA NeMo API


def generate_roadmap(company_info):
    prompt = (f"Generate a roadmap for {company_info['company_name']} in the {company_info['industry']} industry "
              f"at the {company_info['funding_stage']} stage with business goals of {company_info['business_goals']}.")
    completion = client.chat.completions.create(
        model="nvidia/llama-3.1-nemotron-70b-instruct",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.5,
        top_p=1,
        max_tokens=1024,
        stream=True
    )

    roadmap_text = ""
    for chunk in completion:
        if chunk.choices[0].delta.content is not None:
            roadmap_text += chunk.choices[0].delta.content
    return roadmap_text


# Load data from a CSV file
df = pd.read_csv(
    'V:/OneDrive/Desktop/StateNightOwl/Testing_Models/smedata.csv')

# Features and target
X = df[['revenue_growth', 'profit_margin',
        'market_size', 'credit_risk', 'investor_preference']]
y = df['suitable_investment']

# Split the data
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42)

# Train a DecisionTree model
model = DecisionTreeClassifier(random_state=42)
model.fit(X_train, y_train)

# Make predictions
y_pred = model.predict(X_test)

# Evaluate the model
accuracy = accuracy_score(y_test, y_pred)
print(f'Accuracy: {accuracy}')

# Generate graphs


def generate_graphs(df):
    # Plot 1: Distribution of Revenue Growth
    plt.figure(figsize=(10, 6))
    sns.histplot(df['revenue_growth'], kde=True)
    plt.title('Distribution of Revenue Growth')
    plt.xlabel('Revenue Growth')
    plt.ylabel('Frequency')
    plt.savefig('revenue_growth_distribution.png')
    plt.close()

    # Plot 2: Correlation Heatmap
    plt.figure(figsize=(10, 6))
    sns.heatmap(df.corr(), annot=True, cmap='coolwarm')
    plt.title('Correlation Heatmap')
    plt.savefig('correlation_heatmap.png')
    plt.close()

    # Plot 3: Boxplot of Market Size by Suitable Investment
    plt.figure(figsize=(10, 6))
    sns.boxplot(x='suitable_investment', y='market_size', data=df)
    plt.title('Market Size by Suitable Investment')
    plt.xlabel('Suitable Investment')
    plt.ylabel('Market Size')
    plt.savefig('market_size_boxplot.png')
    plt.close()


# Generate the graphs
generate_graphs(df)

# Function to generate PDF report


def generate_pdf_report(suggestion, company_info, roadmap_text):
    # Create a PDF document
    doc = SimpleDocTemplate("funding_roadmap.pdf", pagesize=letter)
    elements = []

    # Styles
    styles = getSampleStyleSheet()
    title_style = styles['Title']
    heading_style = styles['Heading2']
    normal_style = styles['Normal']

    # Title
    elements.append(Paragraph("Funding Roadmap Report", title_style))

    # Model Accuracy
    elements.append(Paragraph(f"Model Accuracy: {accuracy:.2f}", normal_style))

    # Investment Suggestion
    elements.append(Paragraph(
        f"Investment Suggestion: {'Suitable' if suggestion[0] == 1 else 'Not Suitable'}", normal_style))

    # Company Information
    elements.append(
        Paragraph(f"Company Name: {company_info['company_name']}", heading_style))
    elements.append(
        Paragraph(f"Industry: {company_info['industry']}", normal_style))
    elements.append(
        Paragraph(f"Funding Stage: {company_info['funding_stage']}", normal_style))
    elements.append(
        Paragraph(f"Business Goals: {company_info['business_goals']}", normal_style))

    # Detailed Activity Breakdown
    elements.append(Paragraph("Detailed Activity Breakdown", heading_style))

    # Split the roadmap text into sections
    roadmap_sections = roadmap_text.split('\n\n')
    for section in roadmap_sections:
        elements.append(Paragraph(section, normal_style))

    # Add graphs
    elements.append(Paragraph("Graphs", heading_style))
    elements.append(Image('revenue_growth_distribution.png',
                    width=4*inch, height=3*inch))
    elements.append(Image('correlation_heatmap.png',
                    width=4*inch, height=3*inch))
    elements.append(Image('market_size_boxplot.png',
                    width=4*inch, height=3*inch))

    # Build the PDF
    doc.build(elements)


@app.route('/generate_report', methods=['POST'])
def generate_report():
    data = request.json
    new_investor = pd.DataFrame({
        'revenue_growth': [data['revenue_growth']],
        'profit_margin': [data['profit_margin']],
        'market_size': [data['market_size']],
        'credit_risk': [data['credit_risk']],
        'investor_preference': [data['investor_preference']]
    })

    suggestion = model.predict(new_investor)
    company_info = {
        'company_name': data['company_name'],
        'industry': data['industry'],
        'funding_stage': data['funding_stage'],
        'business_goals': data['business_goals']
    }

    roadmap_text = generate_roadmap(company_info)
    generate_pdf_report(suggestion, company_info, roadmap_text)

    return jsonify({"message": "Report generated successfully"})


if __name__ == '__main__':
    app.run(debug=True)
