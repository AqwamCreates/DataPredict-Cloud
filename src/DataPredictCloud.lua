local HttpService = game:GetService("HttpService")

local DataPredictURL = "http://api.datapredict.site/"

DataPredictCloud = {}

DataPredictCloud.__index = DataPredictCloud

function DataPredictCloud.new(slotId: string, slotPassword: string, mode: string)
	
	local NewDataPredictCloudInstance = {}
	
	setmetatable(NewDataPredictCloudInstance, DataPredictCloud)
	
	if (typeof(slotId) ~= "string") then error("Invalid slot ID") end
	
	if (typeof(slotPassword) ~= "string") then error("Invalid slot password") end
	
	if (typeof(mode) ~= "string") then error("Invalid mode") end
	
	NewDataPredictCloudInstance.slotId = slotId
	
	NewDataPredictCloudInstance.slotPassword = slotPassword
	
	NewDataPredictCloudInstance.mode = mode
	
	return NewDataPredictCloudInstance
	
end

function DataPredictCloud:generateSlotData(requestType: string)
	
	local slotData = {}

	slotData.slotId = self.slotId

	slotData.slotPassword = self.slotPassword
	
	slotData.requestType = requestType
	
	return slotData
	
end

function DataPredictCloud:send(data: any)
	
	local isSendSuccessful: boolean = false
	
	local slotData = self:generateSlotDataTable("send")
	
	local response: any
	
	slotData.data = data
	
	isSendSuccessful = pcall(function()
		
		response = HttpService:PostAsync(DataPredictURL, slotData, Enum.HttpContentType.ApplicationUrlEncoded, false)
		
	end)
	
	if isSendSuccessful then
		
		isSendSuccessful = (tonumber(response) == 1)
		
	end
	
	return isSendSuccessful

end

function DataPredictCloud:fetch()
	
	local data: any
	
	local isFetchSuccessful: boolean
	
	local response: any
	
	local slotData = self:generateSlotDataTable("fetch")
	
	isFetchSuccessful = pcall(function()

		response = HttpService:PostAsync(DataPredictURL, slotData, Enum.HttpContentType.ApplicationUrlEncoded, false)

	end)

	if isFetchSuccessful then

		data = (tonumber(response) ~= 0)

	end
	
	return isFetchSuccessful, data
	
end

function DataPredictCloud:checkIfHitMaximumRequest()
	
	local isHit: boolean
	
	local isRequestSuccessful: boolean
	
	local response: any
	
	local slotData = self:generateSlotDataTable("check")
	
	isRequestSuccessful = pcall(function()
		
		response = HttpService:PostAsync(DataPredictURL, slotData, Enum.HttpContentType.ApplicationUrlEncoded, false)
		
	end)
	
	if isRequestSuccessful then

		isHit = (tonumber(response) == 1)

	end
	
	return isRequestSuccessful, isHit
	
end

return DataPredictCloud
