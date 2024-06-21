import csv
import argparse

# Function to read a text file and return a list of its lines
def read_file(file_path):
    with open(file_path, 'r') as file:
        return file.read().splitlines()


def main():

    parser = argparse.ArgumentParser()
    parser.add_argument("file_path", type=str, help="File path for the resulting csv")
    args = parser.parse_args()

    # Read values from the text files
    values = read_file('val_hist.txt')
    residuals = read_file('res_hist.txt')

    # Check if both files have the same number of lines
    if len(values) != len(residuals):
        print("The number of lines in the two files does not match.")
        exit(1)

    # Combine the data and write to a CSV file
    with open(args.file_path, 'w', newline='') as csvfile:
        csv_writer = csv.writer(csvfile)
        csv_writer.writerow(['value', 'residual'])  # Write the header
        for value, residual in zip(values, residuals):
            csv_writer.writerow([value, residual])

    print(f"Data combined into {args.file_path} successfully.")

if __name__ == "__main__":
    main()

