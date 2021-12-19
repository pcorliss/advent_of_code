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

func TreeToString(t BinaryNode) string {
	if t.data > -1 {
		return strconv.Itoa(t.data)
	}
	return "[" + TreeToString(*t.left) + "," + TreeToString(*t.right) + "]"
}

func TreeExplode(t BinaryNode) BinaryNode {
	// If any pair is nested inside four pairs,
	// the leftmost such pair explodes.
	stack := []*BinaryNode{&t}
	depthLookup := make(map[*BinaryNode]int)
	leftSideLookup := make(map[*BinaryNode]bool)
	depthLookup[&t] = 0
	found := false
	rightData := 0

	var lastLeft *BinaryNode

	// wind
	for {
		if len(stack) == 0 {
			break
		}
		cur := stack[len(stack)-1]
		stack = stack[:len(stack)-1] // Pop Stack
		// fmt.Println("Node: ", cur, depthLookup[cur], leftSideLookup[cur])
		if !found && depthLookup[cur] == 4 && cur.right != nil && cur.left != nil {
			// fmt.Println("Found Explode Candidate:", cur.left.data, cur.right.data)
			if lastLeft != nil {
				// fmt.Println("LastLeft Not Null:", lastLeft, cur.left.data)
				lastLeft.data += cur.left.data
			}
			rightData = cur.right.data
			cur.left = nil
			cur.right = nil
			cur.data = 0
			found = true
			continue
		}

		if found && cur.data > -1 {
			cur.data += rightData
			break
		}
		if !found && cur.data > -1 {
			// fmt.Println("LastLeft:", cur)
			lastLeft = cur
		}

		if cur.right != nil {
			stack = append(stack, cur.right)
			depthLookup[cur.right] = depthLookup[cur] + 1
			leftSideLookup[cur.right] = false
		}
		if cur.left != nil {
			stack = append(stack, cur.left)
			depthLookup[cur.left] = depthLookup[cur] + 1
			leftSideLookup[cur.left] = true
		}
	}

	return t
}

func TreeSplit(t BinaryNode) BinaryNode {
	stack := []*BinaryNode{&t}
	for {
		if len(stack) == 0 {
			break
		}
		cur := stack[len(stack)-1]
		stack = stack[:len(stack)-1] // Pop Stack

		if cur.data > 9 {
			a := cur.data / 2
			b := a
			if a*2 != cur.data {
				b++
			}
			cur.left = &BinaryNode{nil, nil, a}
			cur.right = &BinaryNode{nil, nil, b}
			cur.data = -1
			break
		}
		if cur.right != nil {
			stack = append(stack, cur.right)
		}
		if cur.left != nil {
			stack = append(stack, cur.left)
		}
	}

	return t
}

func TreeReduce(t BinaryNode) BinaryNode {
	return BinaryNode{}
}

func TreeAdd(a BinaryNode, b BinaryNode) BinaryNode {
	return BinaryNode{}
}

func TreeMagnitude(t BinaryNode) int {
	return 0
}

func Part1(input string) int {
	return 0
}

func Part2(input string) int {
	return 0
}
