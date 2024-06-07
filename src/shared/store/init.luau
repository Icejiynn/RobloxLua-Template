local data = require(script.slices.data)

export type State = {
	data: data.State
}
export type Actions = data.Actions

return {
	data = data,
}
