package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("18/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 18")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Part2(string(inputStr)))
}

func StringToLines(input string) []string {
	return strings.Split(input, "\n")
}

type BinaryNode struct {
	left  *BinaryNode
	right *BinaryNode
	data  int
}

func StringToTree(lines string) []*BinaryNode {
	trees := []*BinaryNode{}
	for i, line := range strings.Split(lines, "\n") {
		stack := []*BinaryNode{}
		tree := BinaryNode{nil, nil, -1}
		stack = append(stack, &tree)
		for _, char := range strings.Split(line, "") {
			_ = i
			switch char {
			case "[":
				curTree := stack[len(stack)-1]
				newTree := BinaryNode{nil, nil, -1}
				stack = append(stack, &newTree)
				curTree.left = &newTree
			case "]":
				stack = stack[:len(stack)-1] // Pop Stack
			case ",":
				stack = stack[:len(stack)-1] // Pop Stack
				curTree := stack[len(stack)-1]
				newTree := BinaryNode{nil, nil, -1}
				curTree.right = &newTree
				stack = append(stack, &newTree)
			default:
				n, err := strconv.Atoi(char)
				if err != nil {
					panic(err)
				}
				curTree := stack[len(stack)-1]
				curTree.data = n
			}
		}
		trees = append(trees, stack[0])
	}
	return trees
}

// Split & Explode Functions?
func TreeReduce(t BinaryNode) BinaryNode {
	return BinaryNode{}
}

func TreeAdd(a BinaryNode, b BinaryNode) BinaryNode {
	return BinaryNode{}
}

func TreeMagnitude(t BinaryNode) int {
	return 0
}

func TreeToString(t BinaryNode) string {
	return ""
}

func Part1(input string) int {
	return 0
}

func Part2(input string) int {
	return 0
}
