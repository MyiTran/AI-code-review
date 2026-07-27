namespace :docs do
  desc "Generate project directory structure in YAML format and update README.md"
  task generate_yaml: :environment do
    ignored_folders = %w[node_modules log tmp public storage vendor .git .idea .vscode .github]
    tree_command = "tree -L 2 -I \"#{ignored_folders.join('|')}\" --noreport"

    output = `#{tree_command}`

    yaml_output = YAML.dump(output).strip

    readme_path = "README.md"
    readme_content = File.read(readme_path)

    regex = /## Project Directory Structure\n.*?```yaml.*?```/m

    new_section = <<~MARKDOWN
      ## Project Directory Structure

      - To generate the directory structure in YAML format, run the following command:

        ```bash
        rake docs:generate_yaml
        ```

      - If you have not installed the tree command, you can install it by running:

        ```bash
        brew install tree
        ```

      ```yaml
      #{yaml_output}
      ```
    MARKDOWN

    updated_content = if readme_content.match?(regex)
                        readme_content.gsub(regex, new_section)
                      else
                        readme_content + "\n\n" + new_section
                      end

    updated_content = updated_content.strip + "\n"
    File.write(readme_path, updated_content)

    puts "✅ README.md has been updated with the latest directory structure in YAML format!"
  end
end
