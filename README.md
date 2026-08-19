# Simfphys Extra Features (SEF)

> A modular framework for extending Simfphys vehicles with configurable dashboards, interactive vehicle features, and future vehicle-specific extensions.

## Project Status

### Work in Progress

SEF is currently under active development and should be considered an experimental framework. Internal APIs may change until the project reaches its first stable release.

Current development is focused on building a clean, extensible architecture rather than maintaining backwards compatibility.

---

## Overview

Simfphys Extra Features (SEF) aims to provide a generic extension framework for Simfphys vehicles without requiring modifications to existing vehicle addons.

Instead of embedding custom logic into every individual vehicle, SEF allows vehicle-specific behavior to be described declaratively while keeping the rendering and execution logic generic.

The long-term goal is to allow new vehicles to be supported by writing configuration data instead of modifying framework code.

---

## Current Features

### Dashboard Rendering

* Dashboard indicator rendering
* Dashboard text rendering
* Configurable positions, rotations and scaling
* Support for custom fonts

### Dashboard Indicators

Built-in support for common vehicle indicators including:

* Turn signals
* Hazard lights
* Parking lights
* Low beam
* High beam
* Handbrake
* Low fuel
* Check engine
* Fog lights

Additional indicator types can be introduced as the framework evolves.

### Text Indicators

Support for configurable dashboard text such as:

* Digital speedometer
* Current gear
* Time
* Outside temperature
* Custom text providers

Text values are generated through reusable formatter functions.

### Feature System

Vehicle interaction framework supporting actions such as:

* Opening trunk
* Opening hood
* Air suspension controls

The feature system currently uses server-side key bindings for its built-in
actions. Making those bindings configurable remains planned work.

### Weather Abstraction

SEF uses a provider-based weather abstraction to obtain environmental information.

Currently supported:

* Default provider
* StormFox provider

Additional weather systems can be integrated without changing dashboard implementations.

---

## Design Goals

The project is built around several core principles:

* Data-driven configuration
* Modular architecture
* Extensibility
* Separation of rendering and logic
* Minimal duplication
* Vehicle-independent rendering systems
* Clean public APIs
* Support for future third-party extensions
* Best performance possible

---

## Repository Structure

The project is organized into independent subsystems. It may change.

Examples include:

* Registry
* Dashboard rendering
* Conditions
* Formatters
* Features
* Weather providers

Each subsystem has a clearly defined responsibility.

Detailed information about the architecture can be found in **ARCHITECTURE.md**.

---

## Current Development Focus

Current work is focused on improving the internal framework rather than adding new vehicle support.

Major areas of development include:

* Feature system
* Configurable key bindings
* Internal API cleanup
* Architecture improvements
* Performance optimizations

---

## Project Philosophy

SEF is designed to become an extensible framework rather than a collection of vehicle-specific scripts.

Whenever possible, new functionality should be implemented by extending existing systems instead of introducing vehicle-specific special cases.

Configuration should describe *what* should happen, while the framework is responsible for *how* it happens.

---

## Stability

This project is not yet considered API-stable.

Internal interfaces may change as the architecture evolves.

Compatibility layers will only be considered after the core framework reaches a stable design.

---

## Documentation

Additional documentation is available in the repository:

* ARCHITECTURE.md
* DEVELOPMENT.md
These documents describe the project's current architecture and development workflow.
