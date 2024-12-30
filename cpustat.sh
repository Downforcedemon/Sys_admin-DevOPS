#!/bin/bash
source cpu {
    driver cpustat
    interval 30s;
}

collector cpu_utilization {
    source cpu;
    type percentage;
    field user;
    field system;
    field idle;
}

display cpu_display {
    collector cpu_utilization;
    label "CPU utilization";
}
