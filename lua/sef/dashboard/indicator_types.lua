SimfphysExtraFeatures = SimfphysExtraFeatures or {}
SimfphysExtraFeatures.Dashboard = SimfphysExtraFeatures.Dashboard or {}

local Dashboard = SimfphysExtraFeatures.Dashboard

Dashboard.PredefinedIndicators = Dashboard.PredefinedIndicators or {}

local Types = Dashboard.PredefinedIndicators
local Conditions = SimfphysExtraFeatures.Conditions

Types.left_signal = Conditions.LeftSignal
Types.right_signal = Conditions.RightSignal
Types.hazard_signal = Conditions.HazardSignal
Types.lowbeam = Conditions.LowBeam
Types.highbeam = Conditions.HighBeam
Types.fog = Conditions.FogLights
Types.parking_lights = Conditions.ParkingLights
Types.handbrake = Conditions.Handbrake
Types.low_fuel = Conditions.LowFuel
Types.check_engine = Conditions.CheckEngine
Types.cruise = Conditions.CruiseMode
Types.engine_running = Conditions.EngineRunning
Types.dashboard_enabled = Conditions.DashboardEnabled
Types.lamps = Conditions.LampsEnabled
Types.reverse = Conditions.Gears.IsReverse
Types.neutral = Conditions.Gears.IsNeutral
Types.drive = Conditions.Gears.IsDrive
