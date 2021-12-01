package main

import (
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("02/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Part 01")
	fmt.Println("Result: ", Valid(string(inputStr)))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Valid2(string(inputStr)))
}

func Valid(input string) int {
	re := regexp.MustCompile(`^(\d+)-(\d+) (\w): (\w+)$`)
	lines := strings.Split(input, "\n")
	count := 0
	for _, line := range lines {
		// fmt.Println(re.FindAllStringSubmatch(line, -1)[0])
		seg := re.FindAllStringSubmatch(line, -1)[0]
		a, err := strconv.Atoi(seg[1])
		if err != nil {
			panic(err)
		}
		b, err := strconv.Atoi(seg[2])
		if err != nil {
			panic(err)
		}
		char, str := seg[3], seg[4]
		str_count := strings.Count(str, char)
		if str_count <= b && str_count >= a {
			count++
		}

	}
	return count
}

func Valid2(input string) int {
	re := regexp.MustCompile(`^(\d+)-(\d+) (\w): (\w+)$`)
	lines := strings.Split(input, "\n")
	count := 0
	for _, line := range lines {
		// fmt.Println(re.FindAllStringSubmatch(line, -1)[0])
		seg := re.FindAllStringSubmatch(line, -1)[0]
		a, err := strconv.Atoi(seg[1])
		if err != nil {
			panic(err)
		}
		b, err := strconv.Atoi(seg[2])
		if err != nil {
			panic(err)
		}
		char, str := seg[3], seg[4]
		a_char := string(str[a-1])
		b_char := string(str[b-1])
		if a_char == char || b_char == char {
			count++
		}
		if a_char == char && b_char == char {
			count--
		}
	}

	return count
}
