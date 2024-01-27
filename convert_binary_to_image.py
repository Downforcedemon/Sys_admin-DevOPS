import base64
import os

# Your base64 string; replace 'YOUR_BASE64_STRING' with your actual data
b64_string = 'YOUR_BASE64_STRING'

# Decode the base64 string
decoded_bytes = base64.b64decode(b64_string)

# Specify the directory where you want to save the file
# For example, '/home/username/Documents' for Linux or 'C:/Users/username/Documents' for Windows
save_directory = '/path/to/your/directory'

# Ensure the directory exists
if not os.path.exists(save_directory):
    os.makedirs(save_directory)

# The name of the file
filename = 'output.png'

# The full path to the file
file_path = os.path.join(save_directory, filename)

# Write the decoded data to a file
with open(file_path, 'wb') as file_to_save:
    file_to_save.write(decoded_bytes)

print(f"Image data has been written to '{file_path}'")

