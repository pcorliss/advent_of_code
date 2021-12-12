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
		graph.edges[Edge{a, b}] = true
		graph.lookup[a] = append(graph.lookup[a], b)
		if a != "start" && b != "end" {
			graph.edges[Edge{b, a}] = true
			graph.lookup[b] = append(graph.lookup[b], a)
		}
	}
	return graph
}

func FindPaths(g Graph) map[string]bool {
	paths := make(map[string]bool)
	startingPath := []string{"start"}
	workingPaths := [][]string{startingPath}

	for i := 0; i < 8; i++ {
		if len(workingPaths) == 0 {
			return paths
		}

		newWorkingPaths := [][]string{}
		for _, path := range workingPaths {
			last := path[len(path)-1]
			options, ok := g.lookup[last]
			// if dead end - continue
			if !ok {
				continue
			}
			for _, opt := range options {
				// fmt.Println("  Opts: ", opt)
				dupe := false
				// if small cave - check if visited twice
				if opt != "end" && smallCave(opt) {
					for _, cave := range path {
						if cave == opt {
							dupe = true
							break
						}
					}
					if dupe {
						continue
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
	return paths
}

func Part1(input string) int {
	graph := StringToGraph(input)
	return len(FindPaths(graph))
}

func Part2(input string) int {
	return 0
}
