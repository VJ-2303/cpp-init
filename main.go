// main.go
package main

import (
	"fmt"
	"os"
	"path/filepath"
)

// This constant holds the boilerplate C++ code that we want to write to the new file.
// Using a multiline string literal (backticks “) makes it easy to format.
const cppBoilerplate = `#include <iostream>
using namespace std;

int main() {
    cout << "Hello, World!" << std::endl;
    return 0;
}
`

// This function prints the usage instructions if the user enters the command incorrectly.
func printUsage() {
	fmt.Println("Usage: cpp-init <filename>")
	fmt.Println("  Example: cpp-init my_app")
}

func main() {
	// os.Args is a slice of strings that holds all the arguments passed when you run the program.
	// os.Args[0] is the name of the program itself (e.g., "cpp-init").
	// os.Args[1] is the filename.
	args := os.Args

	// We now expect 2 arguments in total:
	// 1. Program name (e.g., "cpp-init")
	// 2. Filename (e.g., "my_program")
	// If we don't get exactly 2, the user did something wrong.
	if len(args) != 2 {
		fmt.Println("Error: Invalid number of arguments.")
		printUsage()
		os.Exit(1) // Exit with a non-zero status code to indicate an error.
	}

	// The filename is now the first argument after the program name.
	fileName := args[1]

	// Add the .cpp extension if the user didn't provide it.
	// filepath.Ext checks for the extension.
	if filepath.Ext(fileName) == "" {
		fileName += ".cpp"
	}

	// Check if the file already exists to avoid accidentally overwriting it.
	// os.Stat returns information about a file. If it returns an error,
	// we can check if the error means the file doesn't exist.
	if _, err := os.Stat(fileName); err == nil {
		fmt.Printf("Error: File '%s' already exists.\n", fileName)
		os.Exit(1)
	}

	// Now, let's create the file!
	// os.WriteFile is a handy function that takes the filename, the content (as a byte slice),
	// and file permissions. 0644 is a standard permission for text files
	// (owner can read/write, others can only read).
	err := os.WriteFile(fileName, []byte(cppBoilerplate), 0644)
	if err != nil {
		// If something went wrong during file creation, print the error and exit.
		fmt.Printf("Error: Unable to create file '%s': %v\n", fileName, err)
		os.Exit(1)
	}

	// Success!
	fmt.Printf("✅ Successfully created C++ file: %s\n", fileName)
}
