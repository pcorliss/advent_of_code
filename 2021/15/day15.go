package main

import (
	"container/heap"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("15/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 15")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Part2(string(inputStr)))
}

type Point struct {
	x int
	y int
}

type Grid struct {
	points map[Point]int
	width  int
	height int
}

func StringToGrid(input string) Grid {
	points := make(map[Point]int)
	grid := Grid{points, 0, 0}
	lines := strings.Split(input, "\n")
	lastX := 0
	lastY := 0
	for y, line := range lines {
		for x, val := range strings.Split(line, "") {
			n, err := strconv.Atoi(val)
			if err != nil {
				panic(err)
			}
			p := Point{x, y}
			grid.points[p] = n
			lastX = x
		}
		lastY = y
	}
	grid.width = lastX + 1
	grid.height = lastY + 1
	return grid
}

func StringToGridFive(input string, width, height int) Grid {
	points := make(map[Point]int)
	grid := Grid{points, 0, 0}
	lines := strings.Split(input, "\n")
	lastX := 0
	lastY := 0
	for y, line := range lines {
		for x, val := range strings.Split(line, "") {
			n, err := strconv.Atoi(val)
			if err != nil {
				panic(err)
			}
			for y_diff := 0; y_diff < 5; y_diff++ {
				for x_diff := 0; x_diff < 5; x_diff++ {
					p := Point{x + x_diff*width, y + y_diff*height}
					grid.points[p] = (n + x_diff + y_diff)
					if grid.points[p] > 9 {
						grid.points[p] -= 9
					}
					if grid.points[p] > 9 {
						fmt.Println("Point:", p, grid.points[p])
						panic("Something is wrong! point is not valid")
					}
				}
			}
			lastX = x
		}
		lastY = y
	}
	grid.width = (lastX + 1) * 5
	grid.height = (lastY + 1) * 5
	return grid
}

var diffs = []Point{
	{0, -1}, // North
	{1, 0},  // West
	{0, 1},  // South
	{-1, 0}, // East
}

func Neighbors(p Point, w int, h int) []Point {
	points := []Point{}
	for _, diff := range diffs {
		if p.x+diff.x >= w || p.x+diff.x < 0 {
			continue
		}
		if p.y+diff.y >= h || p.y+diff.y < 0 {
			continue
		}
		points = append(points, Point{p.x + diff.x, p.y + diff.y})
	}
	return points
}

// From https://pkg.go.dev/container/heap
type Item struct {
	position Point
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
func (pq *PriorityQueue) update(item *Item, position Point, priority int) {
	item.position = position
	item.priority = priority
	heap.Fix(pq, item.index)
}

func FindPathRisk(g Grid, start Point, end Point) int {
	// Init Priority Queue
	pq := make(PriorityQueue, 1)
	pq[0] = &Item{
		position: start,
		priority: 0,
		index:    0,
	}
	heap.Init(&pq)

	seen := make(map[Point]bool)

	bestRisk := 0

	for pq.Len() > 0 {
		candidate := heap.Pop(&pq).(*Item)
		// fmt.Println("Candidate:", candidate, "Queue:", pq.Len())

		if candidate.position == end {
			if candidate.priority < bestRisk || bestRisk == 0 {
				// fmt.Println("  New Best:", bestRisk, candidate.priority)
				bestRisk = candidate.priority
				return bestRisk
			}
			// fmt.Println("  Pruning, reached end")
			continue
		}

		if candidate.priority > bestRisk && bestRisk != 0 {
			// fmt.Println("  Pruning, high risk")
			continue
		}

		if seen[candidate.position] {
			// fmt.Println("  Pruning, been here before")
			continue
		}
		seen[candidate.position] = true

		for _, neighbor := range Neighbors(candidate.position, g.width, g.height) {
			if seen[neighbor] {
				continue
			}
			item := &Item{
				position: neighbor,
				priority: g.points[neighbor] + candidate.priority,
			}
			heap.Push(&pq, item)
		}
	}

	return bestRisk
}
func Part1(input string) int {
	g := StringToGrid(input)
	fmt.Println("Width & Height:", g.width, g.height)
	return FindPathRisk(g, Point{0, 0}, Point{g.width - 1, g.height - 1})
}

// 393 is too low and also impossible
// Original Grid Construction Code stopped after 50x50 because of hardcoded dimensions
func Part2(input string) int {
	ogg := StringToGrid(input)
	g := StringToGridFive(input, ogg.width, ogg.height)
	fmt.Println("Width & Height:", g.width, g.height)
	fmt.Println("End Point:", g.points[Point{g.width - 1, g.height - 1}])
	return FindPathRisk(g, Point{0, 0}, Point{g.width - 1, g.height - 1})
}
