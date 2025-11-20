#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include <sstream>

struct State {
    std::size_t sales_table_index = 0;
    long sales_table_row = 0;
    long sales = 0;

    std::size_t expenses_table_index = 0;
    long expenses_table_row = 0;
    long expenses = 0;

    std::size_t number_of_tables = 0;

};

State state;

std::vector<std::string> split(const std::string& line, const char separator) {
    std::vector<std::string> parts;
    std::stringstream ss(line);
    std::string item;

    while (std::getline(ss, item, separator)) {
        parts.push_back(item);
    }
    return parts;
}

void process_header(const std::vector<std::string> fields, const std::size_t lineNumber) {
    state.number_of_tables++;

    if (fields[0] == "sales") {
        state.sales_table_index = std::stol(fields[fields.size() - 1]);
        auto tables = split(fields[1], ',');
        auto it = std::find(tables.begin(), tables.end(), "sale_value");
        if (it != tables.end()) {
            state.sales_table_row = std::distance(tables.begin(), it);
        }
    }

    if (fields[0] == "expenses") {
        state.expenses_table_index = std::stol(fields[fields.size() - 1]);
        auto tables = split(fields[1], ',');
        auto it = std::find(tables.begin(), tables.end(), "expense_value");
        if (it != tables.end()) {
            state.expenses_table_row = std::distance(tables.begin(), it);
        }
    }
}

void process_table(const std::string& line, const std::size_t lineNumber) {
    if ((lineNumber - state.number_of_tables) % state.number_of_tables == state.sales_table_index) {
        auto fields = split(line, ';');
        state.sales += std::stol(fields[state.sales_table_row]);;
    }

    if ((lineNumber - state.number_of_tables) % state.number_of_tables == state.expenses_table_index) {
        auto fields = split(line, ';');
        state.expenses += std::stol(fields[state.expenses_table_row]);
    }

}

void process(const std::string& line, const std::size_t lineNumber) {
    auto fields = split(line, '|');

    if (fields.size() == 3) {
        process_header(fields, lineNumber);
    } else {
        process_table(line, lineNumber);
    }

}

int main(int argc, const char * argv[]) {
    if (argc < 2) {
        std::cerr << "Usage: vibe-base <filename>\n";
        return 1;
    }

    const char* filename = argv[1];
    std::ifstream in(filename);

    if (!in) {
        std::cerr << "Failed to open: " << filename << '\n';
        return 1;
    }

    std::string line;
    std::size_t lineNumber = 0;
    while (std::getline(in, line)) {
        if (line.empty()) {
            ++lineNumber;
            continue;
        }
        process(line, lineNumber);
        ++lineNumber;
    }

    std::cout << state.sales - state.expenses << '\n';
    return 0;
}
