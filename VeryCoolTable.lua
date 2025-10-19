export type MagnetsSettings = {
	Enabled: boolean,
	Radius: number,
}

export type SimplicitySettings = {
	Magnets: MagnetsSettings
}

local Simplicity: SimplicitySettings = {
	Magnets = {
		Enabled = true, -- // enable and disable the magnets
		Radius = 15, -- // radius max would be 25
	}
}

return Simplicity
