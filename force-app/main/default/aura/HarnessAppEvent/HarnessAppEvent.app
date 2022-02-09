<aura:application extends="force:slds">
    <aura:attribute name="Id" type="String" default="HarnessApp"/>
    <aura:attribute name="message" type="String" default="defaultMessage" />
    <aura:handler name="childCompEvent" event="c:ComponentEvent" action="{!c.handleCompEvent}" phase="bubble"/>
    <aura:handler  event="c:ApplicationEvent" action="{!c.handleApplEvent}" phase="default"/>
    <div class="slds-box">
        <div class="slds-text">{!v.Id}</div><br/>
        <div class="slds-text">{!v.message}</div>
	<c:GrandParent></c:GrandParent>
    </div>
</aura:application>