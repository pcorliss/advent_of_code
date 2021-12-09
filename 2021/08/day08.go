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
	sigs []map[string]bool
	outs []map[string]bool
	all  []map[string]bool
}

func StringsToSets(strings []string) []map[string]bool {
	sets := []map[string]bool{}
	for _, s := range strings {
		set := StringToSet(s)
		sets = append(sets, set)
	}
	return sets
}

func SetToString(set map[string]bool) string {
	keys := make([]string, 0, len(set))
	for k := range set {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	return strings.Join(keys, "")
}

func StringToSet(s string) map[string]bool {
	set := map[string]bool{}
	for _, char := range strings.Split(s, "") {
		set[char] = true
	}
	return set
}

func StringToSignals(input string) []signal {
	signals := []signal{}
	lines := strings.Split(input, "\n")
	for _, line := range lines {
		parts := strings.Split(line, " | ")
		signals_slice := StringsToSets(strings.Split(parts[0], " "))
		output_slice := StringsToSets(strings.Split(parts[1], " "))
		s := signal{signals_slice, output_slice, append(signals_slice, output_slice...)}
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

func matchingChars(a map[string]bool, b map[string]bool) int {
	count := 0
	for char, _ := range b {
		if a[char] {
			count++
		}
	}
	return count
}

type charSet struct {
	set map[string]bool
}

func Deduce(s signal) map[string]int {
	out := make(map[string]int)
	lookup := [10]map[string]bool{}
	// 	sigs := []string{}
	// 	sigs = append(sigs, s.sigs...)
	// 	sigs = append(sigs, s.outs...)

	// 	// We should skip duplicates
	for _, s := range s.all {
		l := len(s)
		str := SetToString(s)
		switch l {
		case 2:
			out[str] = 1
			lookup[1] = s
		case 3:
			out[str] = 7
			lookup[7] = s
		case 4:
			out[str] = 4
			lookup[4] = s
		case 7:
			out[str] = 8
			lookup[8] = s
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

	// 	// We should skip lines we already have
	for _, s := range s.all {
		l := len(s)
		str := SetToString(s)
		switch l {
		case 5:
			sum := 100 * matchingChars(lookup[1], s)
			sum += 10 * matchingChars(lookup[4], s)
			sum += matchingChars(lookup[7], s)
			out[str] = l5Lookup[sum]
			// fmt.Println("Sorted:", sorted, "Sum: ", sum, "Lookup:", l5Lookup[sum])
		case 6:
			sum := 100 * matchingChars(lookup[1], s)
			sum += 10 * matchingChars(lookup[4], s)
			sum += matchingChars(lookup[7], s)
			out[str] = l6Lookup[sum]
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
			sorted := SetToString(out)
			mult /= 10
			sum += mult * mapping[sorted]
		}
	}
	return sum
}
