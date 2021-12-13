package main

import (
	"fmt"
	"os"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("12/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 12")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Part2(string(inputStr)))
}

func smallCave(name string) bool {
	chars := strings.Split(name, "")
	return chars[0] == strings.ToLower(chars[0])
}

func largeCave(name string) bool {
	return !smallCave(name)
}

type Edge struct {
	a string
	b string
}

type Graph struct {
	edges  map[Edge]bool
	lookup map[string][]string
}

func StringToGraph(input string) Graph {
	graph := Graph{make(map[Edge]bool), make(map[string][]string)}
	lines := strings.Split(input, "\n")
	for _, line := range lines {
		parts := strings.Split(line, "-")
		a, b := parts[0], parts[1]
		if b == "start" || a == "end" {
			a, b = b, a
		}
		// if line == "end-zg" {
		// 	fmt.Println(a, b)
		// }
		graph.edges[Edge{a, b}] = true
		graph.lookup[a] = append(graph.lookup[a], b)
		if a != "start" && b != "end" {
			graph.edges[Edge{b, a}] = true
			graph.lookup[b] = append(graph.lookup[b], a)
		}
	}
	return graph
}

func FindPaths(g Graph, single bool) map[string]bool {
	paths := make(map[string]bool)
	startingPath := []string{"start"}
	workingPaths := [][]string{startingPath}

	for i := 0; i < 20; i++ {
		if len(workingPaths) == 0 {
			return paths
		}

		newWorkingPaths := [][]string{}
		for _, path := range workingPaths {
			last := path[len(path)-1]
			options, exists := g.lookup[last]
			// if dead end - continue
			if !exists {
				continue
			}
			smallCaves := make(map[string]bool)
			dupeCave := false
			// dupeCaveName := ""
			for _, cave := range path {
				if !smallCave(cave) {
					continue
				}
				if _, exists := smallCaves[cave]; exists {
					dupeCave = true
					// dupeCaveName = cave
				} else {
					smallCaves[cave] = true
				}
			}
			// if dupeCave {
			// 	fmt.Println("Dupe Cave: ", dupeCave, dupeCaveName)
			// }
			for _, opt := range options {
				// fmt.Println("  ", path, "Opts: ", opt)
				// if small cave - check if visited twice
				if opt != "end" && smallCave(opt) {
					// allow one small cave dupe per path
					if single {
						if _, exists := smallCaves[opt]; exists && dupeCave {
							// fmt.Println("    Pruning opt, ", opt, ", already exists, and dupe")
							continue
						}
						// Allow no small cave dupes
					} else {
						if _, exists := smallCaves[opt]; exists {
							// fmt.Println("    Pruning opt, ", opt, ", already exists")
							continue
						}
					}
				}
				pathCopy := make([]string, len(path)+1)
				copy(pathCopy, path)
				pathCopy[len(path)] = opt
				if opt == "end" {
					// if end - join and add to paths
					paths[strings.Join(pathCopy, ",")] = true
				} else {
					newWorkingPaths = append(newWorkingPaths, pathCopy)
				}
			}

			// add to workingPaths
		}
		workingPaths = newWorkingPaths
		// fmt.Println("Paths:", workingPaths)
		// fmt.Println("Finished Paths: ", paths)
	}
	panic("Too many interations!")
}

// That's not the right answer; your answer is too low. (1258)
func Part1(input string) int {
	graph := StringToGraph(input)
	return len(FindPaths(graph, false))
}

func Part2(input string) int {
	graph := StringToGraph(input)
	return len(FindPaths(graph, true))
}
