function common10000_Logic(f1_arg0)
    COMMON_Initialize(f1_arg0)
    if COMMON_EasySetup_Initial(f1_arg0) == false then
        local f1_local0 = f1_arg0:GetEventRequest()
        local f1_local1 = f1_arg0:IsSearchTarget(TARGET_ENE_0)
        if f1_local0 == 100 then
            f1_arg0:AddTopGoal(GOAL_COMMON_ApproachTarget, 5, POINT_INITIAL, 0.5, TARGET_SELF, true, -1)
        elseif f1_local0 == 110 then
            f1_arg0:AddTopGoal(GOAL_COMMON_ApproachTarget, 5, POINT_INITIAL, 0.5, TARGET_SELF, false, -1)
        elseif f1_local0 == 80 and f1_arg0:IsNpcPlayer() == true then
            local f1_local2 = f1_arg0:GetEventRequest(1)
            f1_arg0:AddTopGoal(GOAL_COMMON_Wait, 0.5, TARGET_NONE)
            f1_arg0:AddTopGoal(GOAL_COMMON_WaitWithAnime, 10, 1000 + f1_local2, TARGET_NONE)
        elseif RideRequest(f1_arg0, 10, 6) then
            f1_arg0:AddTopGoal(GOAL_COMMON_Mount, 4, 1.2)
        else
            COMMON_EasySetup3(f1_arg0)
        end
    end
    
end

function common10000_Interupt(f2_arg0, f2_arg1)
    return false
    
end


