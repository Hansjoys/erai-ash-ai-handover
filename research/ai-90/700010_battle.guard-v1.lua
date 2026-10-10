RegisterTableGoal(GOAL_BuddyStandardShield700010_Battle, "BuddyStandardShield700010_Battle")
REGISTER_GOAL_NO_SUB_GOAL(GOAL_BuddyStandardShield700010_Battle, true)

Goal.Initialize = function (f1_arg0, f1_arg1, f1_arg2, f1_arg3)
    f1_arg1:EnableUnfavorableAttackCheck(0, 3000)
    f1_arg1:EnableUnfavorableAttackCheck(0, 3001)
    f1_arg1:EnableUnfavorableAttackCheck(0, 3003)
    f1_arg1:EnableUnfavorableAttackCheck(0, 3004)
    f1_arg1:EnableUnfavorableAttackCheck(0, 3008)
    f1_arg1:EnableUnfavorableAttackCheck(0, 3101)
    f1_arg1:EnableUnfavorableAttackCheck(0, 3010)
    f1_arg1:EnableUnfavorableAttackCheck(0, 3012)
    f1_arg1:EnableUnfavorableAttackCheck(0, 3013)
    f1_arg1:EnableUnfavorableAttackCheck(0, 3017)
    f1_arg1:EnableUnfavorableAttackCheck(0, 3018)
    f1_arg1:EnableUnfavorableAttackCheck(0, 3019)
    f1_arg1:EnableUnfavorableAttackCheck(0, 3020)
    f1_arg1:EnableUnfavorableAttackCheck(0, 3021)
    f1_arg1:EnableUnfavorableAttackCheck(0, 3023)
    f1_arg1:EnableUnfavorableAttackCheck(0, 3024)
    f1_arg1:EnableUnfavorableAttackCheck(0, 3011)
    f1_arg1:EnableUnfavorableAttackCheck(0, 3012)
    f1_arg1:EnableUnfavorableAttackCheck(0, 3023)
    f1_arg1:EnableUnfavorableAttackCheck(0, 3024)
    f1_arg1:EnableUnfavorableAttackCheck(0, 3008)
    
end

Goal.Activate = function (f2_arg0, f2_arg1, f2_arg2)
    Init_Pseudo_Global(f2_arg1, f2_arg2)
    f2_arg1:SetStringIndexedNumber("Dist_SideStep", 5)
    f2_arg1:SetStringIndexedNumber("Dist_BackStep", 5)
    local f2_local0 = {}
    local f2_local1 = {}
    local f2_local2 = {}
    Common_Clear_Param(f2_local0, f2_local1, f2_local2)
    f2_arg1:AddObserveSpecialEffectAttribute(TARGET_HOSTPLAYER, 83)
    f2_arg1:AddObserveSpecialEffectAttribute(TARGET_HOSTPLAYER, 90)
    local f2_local3 = f2_arg1:GetDist(TARGET_ENE_0)
    local f2_localGuardPlayerDist = f2_arg1:GetDist(TARGET_HOSTPLAYER)
    local f2_localGuardCandidate = f2_localGuardPlayerDist <= 8 and f2_local3 <= 12
    local f2_local4 = f2_arg1:GetRandam_Int(1, 100)
    local f2_local5 = f2_arg1:GetExcelParam(AI_EXCEL_THINK_PARAM_TYPE__thinkAttr_doAdmirer)
    if f2_arg1:HasSpecialEffectId(TARGET_SELF, 10312) and f2_arg1:HasSpecialEffectId(TARGET_SELF, 10317) then
        f2_local0[10] = 100
    elseif f2_arg1:HasSpecialEffectId(TARGET_SELF, 10312) and f2_arg1:HasSpecialEffectId(TARGET_SELF, 10318) then
        f2_local0[10] = 100
    elseif f2_arg1:HasSpecialEffectId(TARGET_SELF, 10312) and f2_local5 == 1 and f2_arg1:GetTeamOrder(ORDER_TYPE_Role) == ROLE_TYPE_Kankyaku then
        if f2_local3 >= 20 then
            f2_local0[16] = 100
        elseif f2_local3 >= 3 then
            f2_local0[9] = 10
            f2_local0[15] = 70
            f2_local0[21] = 20
        else
            f2_local0[11] = 100
        end
    elseif f2_arg1:HasSpecialEffectId(TARGET_SELF, 10312) and f2_local5 == 1 and f2_arg1:GetTeamOrder(ORDER_TYPE_Role) == ROLE_TYPE_Torimaki then
        if f2_local3 >= 20 then
            f2_local0[16] = 100
        elseif f2_local3 >= 3 then
            f2_local0[9] = 20
            f2_local0[15] = 50
            f2_local0[21] = 30
        else
            f2_local0[15] = 100
        end
    elseif f2_arg1:HasSpecialEffectId(TARGET_SELF, 10350) == false then
        f2_local0[19] = 100
    elseif f2_local3 >= 6 then
        f2_local0[5] = 0
        f2_local0[6] = 0
        f2_local0[7] = 20
        f2_local0[15] = 0
        f2_local0[16] = 30
        f2_local0[18] = 0
        f2_local0[21] = 50
    elseif f2_local3 >= 2 then
        f2_local0[5] = 20
        f2_local0[6] = 0
        f2_local0[7] = 30
        f2_local0[15] = 20
        f2_local0[16] = 30
        f2_local0[18] = 0
    else
        f2_local0[5] = 35
        f2_local0[6] = 0
        f2_local0[7] = 20
        f2_local0[15] = 35
        f2_local0[16] = 0
        f2_local0[18] = 10
    end
    if f2_arg1:IsFinishTimer(5) == false then
        f2_local0[9] = 0
    end
    if f2_localGuardCandidate and not (f2_arg1:HasSpecialEffectId(TARGET_SELF, 10312) and (f2_arg1:HasSpecialEffectId(TARGET_SELF, 10317) or f2_arg1:HasSpecialEffectId(TARGET_SELF, 10318))) then
        f2_local0[24] = 100
    end
    f2_local1[5] = REGIST_FUNC(f2_arg1, f2_arg2, BuddyStandardShield700010_Act05)
    f2_local1[6] = REGIST_FUNC(f2_arg1, f2_arg2, BuddyStandardShield700010_Act06)
    f2_local1[7] = REGIST_FUNC(f2_arg1, f2_arg2, BuddyStandardShield700010_Act07)
    f2_local1[9] = REGIST_FUNC(f2_arg1, f2_arg2, BuddyStandardShield700010_Act09)
    f2_local1[10] = REGIST_FUNC(f2_arg1, f2_arg2, BuddyStandardShield700010_Act10)
    f2_local1[11] = REGIST_FUNC(f2_arg1, f2_arg2, BuddyStandardShield700010_Act11)
    f2_local1[12] = REGIST_FUNC(f2_arg1, f2_arg2, BuddyStandardShield700010_Act12)
    f2_local1[15] = REGIST_FUNC(f2_arg1, f2_arg2, BuddyStandardShield700010_Act15)
    f2_local1[16] = REGIST_FUNC(f2_arg1, f2_arg2, BuddyStandardShield700010_Act16)
    f2_local1[17] = REGIST_FUNC(f2_arg1, f2_arg2, BuddyStandardShield700010_Act17)
    f2_local1[18] = REGIST_FUNC(f2_arg1, f2_arg2, BuddyStandardShield700010_Act18)
    f2_local1[19] = REGIST_FUNC(f2_arg1, f2_arg2, BuddyStandardShield700010_Act19)
    f2_local1[20] = REGIST_FUNC(f2_arg1, f2_arg2, BuddyStandardShield700010_Act20)
    f2_local1[21] = REGIST_FUNC(f2_arg1, f2_arg2, BuddyStandardShield700010_Act21)
    f2_local1[24] = REGIST_FUNC(f2_arg1, f2_arg2, BuddyStandardShield700010_Act24)
    local f2_local6 = REGIST_FUNC(f2_arg1, f2_arg2, BuddyStandardShield700010_ActAfter_AdjustSpace)
    Common_Battle_Activate(f2_arg1, f2_arg2, f2_local0, f2_local1, f2_local6, f2_local2)
    
end

function BuddyStandardShield700010_Act05(f3_arg0, f3_arg1, f3_arg2)
    local f3_local0 = 3
    local f3_local1 = 4
    local f3_local2 = 10
    local f3_local3 = 50
    local f3_local4 = 100
    local f3_local5 = 4
    local f3_local6 = 8
    Approach_Act_Flex(f3_arg0, f3_arg1, f3_local0, f3_local1, f3_local2, f3_local3, f3_local4, f3_local5, f3_local6)
    local f3_local7 = 3100
    local f3_local8 = 5 - f3_arg0:GetMapHitRadius(TARGET_SELF)
    local f3_local9 = 0
    local f3_local10 = 0
    f3_arg1:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, f3_local7, TARGET_ENE_0, f3_local8, f3_local9, f3_local10, 0, 0)
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
    
end

function BuddyStandardShield700010_Act06(f4_arg0, f4_arg1, f4_arg2)
    local f4_local0 = 3.5 - f4_arg0:GetMapHitRadius(TARGET_SELF)
    local f4_local1 = 3.5 - f4_arg0:GetMapHitRadius(TARGET_SELF) + 0.9
    local f4_local2 = 3.5 - f4_arg0:GetMapHitRadius(TARGET_SELF) + 4
    local f4_local3 = 50
    local f4_local4 = 0
    local f4_local5 = 4
    local f4_local6 = 8
    Approach_Act_Flex(f4_arg0, f4_arg1, f4_local0, f4_local1, f4_local2, f4_local3, f4_local4, f4_local5, f4_local6)
    local f4_local7 = 3006
    local f4_local8 = 5 - f4_arg0:GetMapHitRadius(TARGET_SELF)
    local f4_local9 = 0
    local f4_local10 = 0
    f4_arg1:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, f4_local7, TARGET_ENE_0, f4_local8, f4_local9, f4_local10, 0, 0)
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
    
end

function BuddyStandardShield700010_Act07(f5_arg0, f5_arg1, f5_arg2)
    local f5_local0 = 10
    local f5_local1 = 0
    local f5_local2 = 4
    local f5_local3 = 50
    local f5_local4 = 100
    local f5_local5 = 4
    local f5_local6 = 8
    Approach_Act_Flex(f5_arg0, f5_arg1, f5_local0, f5_local1, f5_local2, f5_local3, f5_local4, f5_local5, f5_local6)
    local f5_local7 = 3101
    local f5_local8 = 5 - f5_arg0:GetMapHitRadius(TARGET_SELF)
    local f5_local9 = 0
    local f5_local10 = 0
    f5_arg1:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, f5_local7, TARGET_ENE_0, f5_local8, f5_local9, f5_local10, 0, 0)
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
    
end

function BuddyStandardShield700010_Act09(f6_arg0, f6_arg1, f6_arg2)
    local f6_local0 = 5
    local f6_local1 = 3023
    local f6_local2 = 3101
    local f6_local3 = TARGET_ENE_0
    local f6_local4 = 30
    local f6_local5 = 0
    local f6_local6 = 0
    local f6_local7 = 0
    f6_arg0:SetTimer(5, 30)
    f6_arg0:AddObserveSpecialEffectAttribute(TARGET_SELF, 5025)
    local f6_local8 = f6_arg0:GetDist(TARGET_ENE_0)
    if f6_local8 >= 4 then
        f6_arg1:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, f6_local0, f6_local1, f6_local3, f6_local4, 0, 0, 0)
    else
        f6_arg1:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, f6_local0, f6_local2, f6_local3, f6_local4, 0, 0, 0)
    end
    GetWellSpace_Odds = 0
    return GetWellSpace_Odds
    
end

function BuddyStandardShield700010_Act10(f7_arg0, f7_arg1, f7_arg2)
    local f7_local0 = 5
    local f7_local1 = 3025
    local f7_local2 = 3101
    local f7_local3 = TARGET_ENE_0
    local f7_local4 = 30
    local f7_local5 = 0
    local f7_local6 = 0
    local f7_local7 = 0
    f7_arg0:SetTimer(5, 30)
    f7_arg0:AddObserveSpecialEffectAttribute(TARGET_SELF, 5025)
    local f7_local8 = f7_arg0:GetDist(TARGET_ENE_0)
    if f7_local8 >= 4 then
        f7_arg1:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, f7_local0, f7_local1, f7_local3, f7_local4, 0, 0, 0)
    else
        f7_arg1:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, f7_local0, f7_local2, f7_local3, f7_local4, 0, 0, 0)
    end
    GetWellSpace_Odds = 0
    return GetWellSpace_Odds
    
end

function BuddyStandardShield700010_Act11(f8_arg0, f8_arg1, f8_arg2)
    local f8_local0 = 3.5 - f8_arg0:GetMapHitRadius(TARGET_SELF)
    local f8_local1 = 3.5 - f8_arg0:GetMapHitRadius(TARGET_SELF) + 0.9
    local f8_local2 = 3.5 - f8_arg0:GetMapHitRadius(TARGET_SELF) + 4
    local f8_local3 = 50
    local f8_local4 = 0
    local f8_local5 = 4
    local f8_local6 = 8
    Approach_Act_Flex(f8_arg0, f8_arg1, f8_local0, f8_local1, f8_local2, f8_local3, f8_local4, f8_local5, f8_local6)
    local f8_local7 = 3011
    local f8_local8 = 5 - f8_arg0:GetMapHitRadius(TARGET_SELF)
    local f8_local9 = 0
    local f8_local10 = 0
    f8_arg1:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, f8_local7, TARGET_ENE_0, f8_local8, f8_local9, f8_local10, 0, 0)
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
    
end

function BuddyStandardShield700010_Act12(f9_arg0, f9_arg1, f9_arg2)
    local f9_local0 = 3.5 - f9_arg0:GetMapHitRadius(TARGET_SELF)
    local f9_local1 = 3.5 - f9_arg0:GetMapHitRadius(TARGET_SELF) + 0.9
    local f9_local2 = 3.5 - f9_arg0:GetMapHitRadius(TARGET_SELF) + 4
    local f9_local3 = 50
    local f9_local4 = 0
    local f9_local5 = 4
    local f9_local6 = 8
    Approach_Act_Flex(f9_arg0, f9_arg1, f9_local0, f9_local1, f9_local2, f9_local3, f9_local4, f9_local5, f9_local6)
    local f9_local7 = 3012
    local f9_local8 = 5 - f9_arg0:GetMapHitRadius(TARGET_SELF)
    local f9_local9 = 0
    local f9_local10 = 0
    f9_arg1:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, f9_local7, TARGET_ENE_0, f9_local8, f9_local9, f9_local10, 0, 0)
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
    
end

function BuddyStandardShield700010_Act15(f10_arg0, f10_arg1, f10_arg2)
    local f10_local0 = 100
    local f10_local1 = f10_arg0:GetRandam_Int(1, 100)
    local f10_local2 = -1
    if f10_local1 <= f10_local0 then
        f10_local2 = 9910
    end
    f10_arg1:AddSubGoal(GOAL_COMMON_SidewayMove, 5, TARGET_ENE_0, f10_arg0:GetRandam_Int(0, 1), f10_arg0:GetRandam_Int(30, 45), true, true, f10_local2)
    GetWellSpace_Odds = 0
    return GetWellSpace_Odds
    
end

function BuddyStandardShield700010_Act16(f11_arg0, f11_arg1, f11_arg2)
    f11_arg1:AddSubGoal(GOAL_COMMON_ApproachTarget, 10, TARGET_ENE_0, f11_arg0:GetRandam_Float(1.5, 2.5), TARGET_SELF, false, 9910)
    GetWellSpace_Odds = 0
    return GetWellSpace_Odds
    
end

function BuddyStandardShield700010_Act17(f12_arg0, f12_arg1, f12_arg2)
    f12_arg1:AddSubGoal(GOAL_COMMON_Wait, 1, TARGET_NONE, 0, 0, 0)
    GetWellSpace_Odds = 0
    return GetWellSpace_Odds
    
end

function BuddyStandardShield700010_Act18(f13_arg0, f13_arg1, f13_arg2)
    f13_arg1:AddSubGoal(GOAL_COMMON_Guard, 5, 9910, TARGET_ENE_0, true, 0)
    GetWellSpace_Odds = 0
    return GetWellSpace_Odds
    
end

function BuddyStandardShield700010_Act19(f14_arg0, f14_arg1, f14_arg2)
    local f14_local0 = 3007
    local f14_local1 = 5 - f14_arg0:GetMapHitRadius(TARGET_SELF)
    local f14_local2 = 0
    local f14_local3 = 0
    f14_arg1:AddSubGoal(GOAL_COMMON_ApproachTarget, 10, TARGET_ENE_0, 6, TARGET_SELF, false, 9910)
    f14_arg1:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, f14_local0, TARGET_ENE_0, f14_local1, f14_local2, f14_local3, 0, 0)
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
    
end

function BuddyStandardShield700010_Act20(f15_arg0, f15_arg1, f15_arg2)
    local f15_local0 = 3012
    local f15_local1 = 5 - f15_arg0:GetMapHitRadius(TARGET_SELF)
    local f15_local2 = 0
    local f15_local3 = 0
    f15_arg1:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, f15_local0, TARGET_ENE_0, f15_local1, f15_local2, f15_local3, 0, 0)
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
    
end

function BuddyStandardShield700010_Act21(f16_arg0, f16_arg1, f16_arg2)
    local f16_local0 = 5
    local f16_local1 = 3031
    local f16_local2 = TARGET_ENE_0
    local f16_local3 = 10
    local f16_local4 = 0
    local f16_local5 = 0
    local f16_local6 = 0
    f16_arg1:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, f16_local0, f16_local1, f16_local2, f16_local3, 0, 0, 0)
    GetWellSpace_Odds = 0
    return GetWellSpace_Odds
    
end

function BuddyStandardShield700010_Act22(f17_arg0, f17_arg1, f17_arg2)
    local f17_local0 = 3020
    local f17_local1 = 3.5 - f17_arg0:GetMapHitRadius(TARGET_SELF)
    local f17_local2 = 0
    local f17_local3 = 0
    f17_arg1:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, f17_local0, TARGET_ENE_0, f17_local1, f17_local2, f17_local3, 0, 0)
    GetWellSpace_Odds = 0
    return GetWellSpace_Odds
    
end

function BuddyStandardShield700010_Act24(f24_arg0, f24_arg1, f24_arg2)
    f24_arg1:AddSubGoal(GOAL_COMMON_ApproachTarget, 3, TARGET_HOSTPLAYER, 3, TARGET_SELF, true, -1)
    f24_arg1:AddSubGoal(GOAL_COMMON_Guard, 5, 9910, TARGET_ENE_0, true, 0)
    GetWellSpace_Odds = 0
    return GetWellSpace_Odds

end

function BuddyStandardShield700010_Act23(f18_arg0, f18_arg1, f18_arg2)
    local f18_local0 = 3021
    local f18_local1 = 3.5 - f18_arg0:GetMapHitRadius(TARGET_SELF)
    local f18_local2 = 0
    local f18_local3 = 0
    f18_arg1:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, f18_local0, TARGET_ENE_0, f18_local1, f18_local2, f18_local3, 0, 0)
    GetWellSpace_Odds = 0
    return GetWellSpace_Odds
    
end

function BuddyStandardShield700010_Act40(f19_arg0, f19_arg1, f19_arg2)
    local f19_local0 = f19_arg0:GetDist(TARGET_ENE_0)
    local f19_local1 = f19_arg0:GetRandam_Int(1, 100)
    local f19_local2 = f19_arg0:GetDist(TARGET_HOSTPLAYER)
    if f19_local2 <= 2.5 then
        f19_arg1:AddSubGoal(GOAL_COMMON_LeaveTarget, 2, TARGET_HOSTPLAYER, 3, TARGET_HOSTPLAYER, true, -1)
    elseif f19_local2 <= 5 then
        f19_arg1:AddSubGoal(GOAL_COMMON_ApproachTarget, 2, TARGET_HOSTPLAYER, 4, TARGET_SELF, true, -1)
    else
        f19_arg1:AddSubGoal(GOAL_COMMON_ApproachTarget, 10, TARGET_HOSTPLAYER, 4, TARGET_SELF, false, -1)
    end
    GetWellSpace_Odds = 0
    return GetWellSpace_Odds
    
end

function BuddyStandardShield700010_Act50(f20_arg0, f20_arg1, f20_arg2)
    f20_arg0:SetNumber(1, 1)
    f20_arg1:AddSubGoal(GOAL_COMMON_Wait, f20_arg0:GetRandam_Float(0.1, 1.5), TARGET_NONE, 0, 0, 0)
    f20_arg1:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, f20_arg0:GetRandam_Int(3031, 3033), TARGET_ENE_0, DIST_None, 0, 90)
    GetWellSpace_Odds = 0
    return GetWellSpace_Odds
    
end

function BuddyStandardShield700010_ActAfter_AdjustSpace(f21_arg0, f21_arg1, f21_arg2)
    f21_arg1:AddSubGoal(GOAL_BuddyStandardShield700010_AfterAttackAct, 10)
    
end

Goal.Update = function (f22_arg0, f22_arg1, f22_arg2)
    return Update_Default_NoSubGoal(f22_arg0, f22_arg1, f22_arg2)
    
end

Goal.Terminate = function (f23_arg0, f23_arg1, f23_arg2)
    
end

Goal.Interrupt = function (f24_arg0, f24_arg1, f24_arg2)
    local f24_local0 = f24_arg1:GetDist(TARGET_ENE_0)
    local f24_local1 = f24_arg1:GetRandam_Int(1, 100)
    local f24_local2 = f24_arg1:GetDist(TARGET_HOSTPLAYER)
    if f24_arg1:IsInterupt(INTERUPT_ActivateSpecialEffect) then
        if f24_arg1:GetSpecialEffectActivateInterruptId(83) and f24_local2 <= 5 then
            f24_arg2:ClearSubGoal()
            f24_arg2:AddSubGoal(GOAL_COMMON_ApproachTarget, 3, TARGET_HOSTPLAYER, 0.5, TARGET_SELF, false, 9910)
            f24_arg2:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 2, 3012, TARGET_ENE_0, 0.5, 0, 0, 0, 0)
            return true
        end
        if f24_arg1:GetSpecialEffectActivateInterruptId(90) and f24_local2 <= 5 then
            f24_arg2:ClearSubGoal()
            f24_arg2:AddSubGoal(GOAL_COMMON_ApproachTarget, 3, TARGET_HOSTPLAYER, 0.5, TARGET_SELF, false, 9910)
            f24_arg2:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 2, 3012, TARGET_ENE_0, 0.5, 0, 0, 0, 0)
            return true
        end
        if f24_arg1:HasSpecialEffectId(TARGET_SELF, 5025) then
            f24_arg1:DeleteObserveSpecialEffectAttribute(TARGET_SELF, 5025)
            f24_arg2:ClearSubGoal()
            local f24_local3 = f24_arg1:GetDist(TARGET_ENE_0)
            if f24_local3 <= 4 then
                local f24_local4 = 5
                local f24_local5 = 3101
                local f24_local6 = TARGET_ENE_0
                local f24_local7 = 10
                local f24_local8 = 0
                local f24_local9 = 0
                local f24_local10 = 0
                f24_arg2:AddSubGoal(GOAL_COMMON_ComboRepeat, f24_local4, f24_local5, f24_local6, f24_local7, 0, 0, 0)
            else
                f24_arg1:AddObserveSpecialEffectAttribute(TARGET_SELF, 5026)
                local f24_local4 = 25
                local f24_local5 = 3031
                local f24_local6 = TARGET_ENE_0
                local f24_local7 = 30
                local f24_local8 = 0
                local f24_local9 = 0
                local f24_local10 = 0
                f24_arg2:AddSubGoal(GOAL_COMMON_ComboRepeat, f24_local4, f24_local5, f24_local6, f24_local7, 0, 0, 0)
                f24_arg2:AddSubGoal(GOAL_COMMON_ComboRepeat, f24_local4, f24_local5, f24_local6, f24_local7, 0, 0, 0)
                f24_arg2:AddSubGoal(GOAL_COMMON_ComboRepeat, f24_local4, f24_local5, f24_local6, f24_local7, 0, 0, 0)
                f24_arg2:AddSubGoal(GOAL_COMMON_ComboRepeat, f24_local4, f24_local5, f24_local6, f24_local7, 0, 0, 0)
                f24_arg2:AddSubGoal(GOAL_COMMON_ComboRepeat, f24_local4, f24_local5, f24_local6, f24_local7, 0, 0, 0)
            end
            return true
        end
        if f24_arg1:HasSpecialEffectId(TARGET_SELF, 5026) then
            local f24_local3 = f24_arg1:GetDist(TARGET_ENE_0)
            if f24_local3 <= 4 then
                f24_arg2:ClearSubGoal()
            end
        end
    end
    return false
    
end

RegisterTableGoal(GOAL_BuddyStandardShield700010_AfterAttackAct, "BuddyStandardShield700010_AfterAttackAct")
REGISTER_GOAL_NO_SUB_GOAL(GOAL_BuddyStandardShield700010_AfterAttackAct, true)

Goal.Activate = function (f25_arg0, f25_arg1, f25_arg2)
    
end

Goal.Update = function (f26_arg0, f26_arg1, f26_arg2)
    return Update_Default_NoSubGoal(f26_arg0, f26_arg1, f26_arg2)
    
end


