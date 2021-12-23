package main

import (
	"container/heap"
	"fmt"
	"os"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("23/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 23")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Part2(string(inputStr)))
}

// From https://pkg.go.dev/container/heap
type Item struct {
	state    State
	priority int // The priority of the item in the queue.
	// The index is needed by update and is maintained by the heap.Interface methods.
	index int // The index of the item in the heap.
}

type PriorityQueue []*Item

func (pq PriorityQueue) Len() int { return len(pq) }

func (pq PriorityQueue) Less(i, j int) bool {
	// We want Pop to give us the highest, not lowest, priority so we use greater than here.
	return pq[i].priority < pq[j].priority
}

func (pq PriorityQueue) Swap(i, j int) {
	pq[i], pq[j] = pq[j], pq[i]
	pq[i].index = i
	pq[j].index = j
}

func (pq *PriorityQueue) Push(x interface{}) {
	n := len(*pq)
	item := x.(*Item)
	item.index = n
	*pq = append(*pq, item)
}

func (pq *PriorityQueue) Pop() interface{} {
	old := *pq
	n := len(old)
	item := old[n-1]
	old[n-1] = nil  // avoid memory leak
	item.index = -1 // for safety
	*pq = old[0 : n-1]
	return item
}

// update modifies the priority and value of an Item in the queue.
func (pq *PriorityQueue) update(item *Item, state State, priority int) {
	item.state = state
	item.priority = priority
	heap.Fix(pq, item.index)
}

type Point struct {
	x int
	y int
}

var boardLookup = map[Point]int{
	{1, 1}:  0,  // Hallway Far Left
	{2, 1}:  1,  // Hallway Almost Far Left
	{4, 1}:  2,  // Between A/B
	{6, 1}:  3,  // Between B/C
	{8, 1}:  4,  // Between C/D
	{10, 1}: 5,  // Hallway Almost Far Right
	{11, 1}: 6,  // Hallway Far Right
	{3, 2}:  7,  // A Col
	{5, 2}:  8,  // B Col
	{7, 2}:  9,  // C Col
	{9, 2}:  10, // D Col
	{3, 3}:  11, // A Col
	{5, 3}:  12, // B Col
	{7, 3}:  13, // C Col
	{9, 3}:  14, // D Col
}

var pointLookup = [15]Point{
	{1, 1},
	{2, 1},
	{4, 1},
	{6, 1},
	{8, 1},
	{10, 1},
	{11, 1},
	{3, 2},
	{5, 2},
	{7, 2},
	{9, 2},
	{3, 3},
	{5, 3},
	{7, 3},
	{9, 3},
}

var runeLookup = map[string]rune{
	"A": 65,
	"B": 66,
	"C": 67,
	"D": 68,
}

type State struct {
	energy int
	board  [15]Lizard // Using an array for easier past board state tracking
}

type Lizard struct {
	id  int
	typ rune
}

func StringToState(input string) State {
	state := State{0, [15]Lizard{}}
	charCount := make(map[rune]int)
	for y, line := range strings.Split(input, "\n") {
		for x, char := range strings.Split(line, "") {
			idx, exists := boardLookup[Point{x, y}]
			if exists && char != "." && char != "#" {
				char := []rune(char)[0]
				charCount[char]++
				l := Lizard{charCount[char], char}
				state.board[idx] = l
			}
		}
	}
	return state
}

func ValidDest(state State, beg, dest Point) bool {
	// Is it blocked?
	// Can this Lizard go to this spot?
	// Is this lizard allowed to move to this final spot?
	// 2.0 will never move from the hallway into a room unless that room is their destination room
	// 2.1 and that room contains no amphipods which do not also have that room as their own destination.
	// 3.0 rom the hallway it will stay in that spot until it can move into a room
	return false
}

func Part1(input string) int {
	return 0
}

func Part2(input string) int {
	return 0
}
