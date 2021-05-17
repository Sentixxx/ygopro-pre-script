--SRマジックハウンド
--Script by XyLeN
function c100425002.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100425002,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c100425002.tgtg)
	e1:SetOperation(c100425002.tgop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(100425002,1)) 
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,100425002)
	e2:SetCondition(aux.exccon) 
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100425002.sptg)
	e2:SetOperation(c100425002.spop)
	c:RegisterEffect(e2)
end
function c100425002.tgfilter(c)
	return c:IsSetCard(0x2016) and c:IsAbleToGrave()
end
function c100425002.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100425002.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c100425002.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100425002.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c100425002.tdfilter(c,e,tp)
	return c:IsSetCard(0x2016) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c100425002.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel(),c:GetCode())
end
function c100425002.spfilter(c,e,tp,lv,code)
	return c:IsLevel(lv) and not c:IsCode(code) and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x2016)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c100425002.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c100425002.tdfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c100425002.tdfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c100425002.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100425002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
		local lv,code=tc:GetLevel(),tc:GetCode()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c100425002.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv,code)
		local tc=g:GetFirst() 
		if tc then
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			tc:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
		end
	end
end