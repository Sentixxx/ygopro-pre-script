--聖天樹の大精霊
--
--Script by JustFish
function c100270212.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c100270212.mfilter,2,99)
	c:EnableReviveLimit()
	--cannot be battle traget
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100270212,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(3)
	e2:SetCondition(c100270212.spcon)
	e2:SetTarget(c100270212.sptg)
	e2:SetOperation(c100270212.spop)
	c:RegisterEffect(e2)
	--negate attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100270212,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c100270212.mvcon)
	e4:SetTarget(c100270212.mvtg)
	e4:SetOperation(c100270212.mvop)
	c:RegisterEffect(e4)
end
function c100270212.mfilter(c)
	return c:IsLinkRace(RACE_PLANT)
end
function c100270212.spfilter(c,e,tp)
	return c:IsSetCard(0x255) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c100270212.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c100270212.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c100270212.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100270212.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Recover(tp,ev,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c100270212.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c100270212.mvcon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d and d:IsControler(tp) and d:IsFaceup() and e:GetHandler():GetLinkedGroup():IsContains(d)
end
function c100270212.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
end
function c100270212.mvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	if Duel.NegateAttack() and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		local nseq=math.log(s,2)
		Duel.MoveSequence(tc,nseq)
	end
end