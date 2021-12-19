package main

import (
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("19/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 19")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Part2(string(inputStr)))
}

type Point struct {
	x int
	y int
	z int
}

type Sensor struct {
	readings []Point
}

func StringToSensors(input string) []Sensor {
	sensors := []Sensor{}
	lines := strings.Split(input, "\n")
	var curSensor Sensor
	for j, line := range lines {
		if len(line) == 0 {
			continue
		}
		if strings.Contains(line, "---") {
			if j > 0 {
				sensors = append(sensors, curSensor)
			}
			curSensor = Sensor{[]Point{}}
			continue
		}
		point := Point{}
		for i, dim := range strings.Split(line, ",") {
			n, err := strconv.Atoi(dim)
			if err != nil {
				panic(err)
			}
			switch i {
			case 0:
				point.x = n
			case 1:
				point.y = n
			case 2:
				point.z = n
			default:
				panic("Too many entries in line")
			}
		}
		curSensor.readings = append(curSensor.readings, point)
	}
	sensors = append(sensors, curSensor)
	return sensors
}

func SameOct(a, b Point) bool {
	return math.Signbit(float64(a.x)) == math.Signbit(float64(b.x)) && math.Signbit(float64(a.y)) == math.Signbit(float64(b.y)) && math.Signbit(float64(a.z)) == math.Signbit(float64(b.z))
}

func CalcBeaconToBeaconDistance(readings []Point) map[int][]Point {
	distance := make(map[int][]Point)
	calculated := make(map[Point]bool)
	for _, a := range readings {
		calculated[a] = true
		for _, b := range readings {
			if a == b {
				continue
			}
			if calculated[b] {
				continue
			}
			dist := int(math.Abs(float64(a.x-b.x)) + math.Abs(float64(a.y-b.y)) + math.Abs(float64(a.z-b.z)))
			distance[dist] = []Point{a, b}
		}
	}
	return distance
}

func CompareDistancesBetweenSensors(sensors []Sensor) {
	distances := []map[int][]Point{}
	for _, s := range sensors {
		distance := CalcBeaconToBeaconDistance(s.readings)
		distances = append(distances, distance)
	}

	seen := make(map[int]bool)
	i := 0
	// for i := range sensors {
	seen[i] = true
	for j := range sensors {
		match := 0
		if i == j || seen[j] {
			continue
		}

		// pointSet := make(map[Point]bool)
		for dist, _ := range distances[i] {
			if _, exists := distances[j][dist]; exists {
				match++
				// pointSet[distances[i][dist][0]] = true
				// pointSet[distances[i][dist][1]] = true
				// pointSet[distances[j][dist][0]] = true
				// pointSet[distances[j][dist][1]] = true
			}
		}

		fmt.Println("Found ", match, "matches between", i, "and", j)
	}
	// }
}

func Part1(input string) int {
	sensors := StringToSensors(input)
	CompareDistancesBetweenSensors(sensors)
	return 0
}

func Part2(input string) int {
	return 0
}
