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
	for char := range b {
		if a[char] {
			count++
		}
	}
	return count
}

type lup struct {
	length int
	one    int
	four   int
}

// Length, matching segments for one digit, four, and seven
var NumLookup = map[lup]int{
	{5, 1, 2}: 2,
	{5, 2, 3}: 3,
	{5, 1, 3}: 5,
	{6, 2, 2}: 0,
	{6, 1, 3}: 6,
	{6, 2, 4}: 9,
}

// character length matcher
var LengthLookup = map[int]int{
	2: 1,
	3: 7,
	4: 4,
	7: 8,
}

func Deduce(s signal) map[string]int {
	out := make(map[string]int)
	lookup := [10]map[string]bool{}
	seen := make(map[string]bool)

	for _, s := range s.all {
		l := len(s)
		str := SetToString(s)
		if seen[str] {
			continue
		}
		match := LengthLookup[l]
		if match != 0 {
			out[str] = match
			lookup[match] = s
			seen[str] = true
		}
	}

	for _, s := range s.all {
		l := len(s)
		str := SetToString(s)
		if seen[str] {
			continue
		}
		if l == 5 || l == 6 {
			out[str] = NumLookup[lup{
				l,
				matchingChars(lookup[1], s),
				matchingChars(lookup[4], s),
			}]
			seen[str] = true
		}
	}

	return out
}

func Part2(input string) int {
	signals := StringToSignals(input)
	sum := 0
	for _, s := range signals {
		mapping := Deduce(s)
		mult := 1000
		for _, out := range s.outs {
			sorted := SetToString(out)
			sum += mult * mapping[sorted]
			mult /= 10
		}
	}
	return sum
}
