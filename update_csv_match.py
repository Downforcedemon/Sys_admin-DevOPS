import pandas as pd

def update_tax_code(csv_file, item_code_list, output_file):
    """
    Updates the TAX_CODE column in a CSV file by adding 'G' to matching ITEM_CODE entries.

    Args:
        csv_file (str): Path to the input CSV file.
        item_code_list (list): List of ITEM_CODE values to match.
        output_file (str): Path to save the updated CSV file.
    """
    try:
        # Load the CSV into a DataFrame
        df = pd.read_csv(csv_file)
        
        # Strip leading/trailing spaces and normalize column names
        df.columns = df.columns.str.strip().str.upper()

        # Ensure the required columns are present
        if 'ITEM_CODE' not in df.columns or 'TAX_CODE' not in df.columns:
            raise ValueError("The CSV file must have 'ITEM_CODE' and 'TAX_CODE' columns.")

        # Ensure TAX_CODE is treated as a string
        df['TAX_CODE'] = df['TAX_CODE'].fillna('').astype(str)

        # Update TAX_CODE where ITEM_CODE matches the provided list
        df['TAX_CODE'] = df.apply(
            lambda row: row['TAX_CODE'] + 'G' if row['ITEM_CODE'] in item_code_list else row['TAX_CODE'], 
            axis=1
        )
        
        # Save the updated DataFrame to a new CSV file
        df.to_csv(output_file, index=False)
        print(f"Updated CSV saved as: {output_file}")
    
    except Exception as e:
        print(f"An error occurred: {e}")

# Example usage
if __name__ == "__main__":
    # Replace with your input CSV file path and desired output file path
    input_csv = "input.csv"
    output_csv = "output.csv"
    
    # Replace with your list of ITEM_CODE values
    item_codes_to_update = ['ITEM1', 'ITEM2', 'ITEM3']
    
    # Run the update function
    update_tax_code(input_csv, item_codes_to_update, output_csv)
