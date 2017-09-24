extends Node

const ENGAGE_DISTANCE = 2000
const LASER_ATTACK_RANGE = 800

const SPEED_MAX = 30.0
const ROT_SPEED_MAX = 20.0
const ROT_FRICTION = 7.5

const TEAM = { 0:'Neutral', 1:'BlueTeam', 2:'RedTeam', 3:'GreenTeam', 4:'YellowTeam' }
var TEAM_COLORS = { 0: Colors.Gray, 1: Colors.Blue, 2: Colors.Red, 3: Colors.Green, 4: Colors.Yellow }