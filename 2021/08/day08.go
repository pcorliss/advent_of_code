package main

import (
	"fmt"
	"os"
	"sort"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("08/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 08")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))
	// Info(string(inputStr))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Part2(string(inputStr)))
}

type signal struct {
	sigs []string
	outs []string
}

func StringToSignals(input string) []signal {
	signals := []signal{}
	lines := strings.Split(input, "\n")
	for _, line := range lines {
		parts := strings.Split(line, " | ")
		signals_slice := strings.Split(parts[0], " ")
		output_slice := strings.Split(parts[1], " ")
		s := signal{signals_slice, output_slice}
		signals = append(signals, s)
	}
	return signals
}

func Part1(input string) int {
	signals := StringToSignals(input)
	count := 0
	for _, s := range signals {
		for _, out := range s.outs {
			l := len(out)
			if l == 7 || l == 2 || l == 3 || l == 4 {
				count++
			}
		}
	}
	return count
}

func Info(input string) {
	signals := StringToSignals(input)
	match := [8]bool{}
	for _, s := range signals {
		for _, out := range s.sigs {
			l := len(out)
			switch l {
			case 2, 3, 4, 7:
				match[l] = true
			}
		}
		for _, out := range s.outs {
			l := len(out)
			switch l {
			case 2, 3, 4, 7:
				match[l] = true
			}
		}
		fmt.Print(match[2] && match[3] && match[4] && match[7])
		fmt.Print(" - ")
		fmt.Println(s)
	}
}

// https://stackoverflow.com/questions/22688651/golang-how-to-sort-string-or-byte
func SortString(w string) string {
	s := strings.Split(w, "")
	sort.Strings(s)
	return strings.Join(s, "")
}

func matchingChars(a string, b string) int {
	m := make(map[string]bool)
	count := 0
	for _, char := range strings.Split(a, "") {
		m[char] = true
	}
	for _, char := range strings.Split(b, "") {
		if m[char] {
			count++
		}
	}
	return count
}

func Deduce(s signal) map[string]int {
	out := make(map[string]int)
	lookup := [10]string{}
	sigs := []string{}
	sigs = append(sigs, s.sigs...)
	sigs = append(sigs, s.outs...)

	// We should skip duplicates
	for _, s := range sigs {
		sorted := SortString(s)
		l := len(s)
		switch l {
		case 2:
			out[sorted] = 1
			lookup[1] = sorted
		case 3:
			out[sorted] = 7
			lookup[7] = sorted
		case 4:
			out[sorted] = 4
			lookup[4] = sorted
		case 7:
			out[sorted] = 8
			lookup[8] = sorted
		}
	}

	// 1,4,7 matching chars * 100, 10, and 1 and summed
	l5Lookup := make(map[int]int)
	l5Lookup[122] = 2
	l5Lookup[233] = 3
	l5Lookup[132] = 5
	l6Lookup := make(map[int]int)
	l6Lookup[222] = 0
	l6Lookup[132] = 6
	l6Lookup[243] = 9

	// We should skip lines we already have
	for _, s := range sigs {
		sorted := SortString(s)
		l := len(s)
		switch l {
		case 5:
			sum := 100 * matchingChars(lookup[1], sorted)
			sum += 10 * matchingChars(lookup[4], sorted)
			sum += matchingChars(lookup[7], sorted)
			out[sorted] = l5Lookup[sum]
			// fmt.Println("Sorted:", sorted, "Sum: ", sum, "Lookup:", l5Lookup[sum])
		case 6:
			sum := 100 * matchingChars(lookup[1], sorted)
			sum += 10 * matchingChars(lookup[4], sorted)
			sum += matchingChars(lookup[7], sorted)
			out[sorted] = l6Lookup[sum]
			// if sorted == "abcdef" {
			// 	fmt.Println("Sorted:", sorted, "Sum: ", sum, "Lookup:", l6Lookup[sum])
			// }
		}
	}

	return out
}

func Part2(input string) int {
	signals := StringToSignals(input)
	sum := 0
	for _, s := range signals {
		mapping := Deduce(s)
		mult := 10000
		for _, out := range s.outs {
			sorted := SortString(out)
			mult /= 10
			sum += mult * mapping[sorted]
		}
	}
	return sum
}
