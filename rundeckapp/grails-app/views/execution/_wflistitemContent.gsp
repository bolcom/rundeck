%{--
  - Copyright 2016 SimplifyOps, Inc. (http://simplifyops.com)
  -
  - Licensed under the Apache License, Version 2.0 (the "License");
  - you may not use this file except in compliance with the License.
  - You may obtain a copy of the License at
  -
  -     http://www.apache.org/licenses/LICENSE-2.0
  -
  - Unless required by applicable law or agreed to in writing, software
  - distributed under the License is distributed on an "AS IS" BASIS,
  - WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  - See the License for the specific language governing permissions and
  - limitations under the License.
  --}%
<%--
    _wflistitemContent.gsp
    
    Author: Greg Schueler <a href="mailto:greg@dtosolutions.com">greg@dtosolutions.com</a>
    Created: Jul 27, 2010 3:53:40 PM
    $Id$


 --%><div id="wfivis_${enc(attr:i)}" style="${i==highlight?'opacity: 0':''}">
    <div class="pflowitem wfctrlholder">
        <span class="pflow item " id="wfitem_${enc(attr:i)}" >
        <g:if test="${isErrorHandler}">
            <span class="text-muted"><g:message code="Workflow.stepErrorHandler.label.on.error" /></span>
        </g:if>
        <g:render template="/execution/wfItemView" model="${[item:item,edit:edit,noimgs:noimgs, workflow: workflow, project: project]}"/>
        <g:if test="${edit}">
        <div id="itemdel_${i}" class="panel panel-danger collapse">
            <div class="panel-heading">
                <g:message code="${'Workflow.' + (isErrorHandler ? 'stepErrorHandler' : 'step') + '.action.delete.label'}"/>
            </div>
            <div class="panel-body">
                <g:if test="${isErrorHandler}">
                    <g:message code="Workflow.stepErrorHandler.label.action.confirmDelete" args="${[stepNum + 1]}"/>
                </g:if>
                <g:else>
                    <g:message code="Workflow.step.action.confirmDelete.label" args="${[stepNum + 1]}"/>
                </g:else>
            </div>

            <div class="panel-footer">
                <span class="btn btn-default btn-xs"
                      onclick="jQuery('#itemdel_${i}').collapse('toggle');"><g:message code="cancel"/></span>
                <span class="btn btn-danger btn-xs" onclick=" _doRemoveItem('${i}', '${stepNum}', ${isErrorHandler?true:false});"><g:message code="delete"/></span>
            </div>
        </div>
        </g:if>
        <g:if test="${isErrorHandler}">
            <g:if test="${item.keepgoingOnSuccess}">
                <span class=" succeed" title="${enc(code:'Workflow.stepErrorHandler.keepgoingOnSuccess.description')}"><g:message code="Workflow.stepErrorHandler.label.keep.going.on.success" /></span>
            </g:if>
        </g:if>
    </span>
        <g:unless test="${stepNum!=null}">
            <g:set var="stepNum" value="${i}"/>
        </g:unless>

    <g:if test="${edit}">
        <span class="wfitemcontrols controls " id="pfctrls_${enc(attr:i)}" >
            <g:if test="${!isErrorHandler && !item.errorHandler}">
                <span class="textbtn textbtn-success wfitem_add_errorhandler">
                    <i class="glyphicon glyphicon-plus"></i><g:message code="Workflow.stepErrorHandler.label"/></span>
            </g:if>

            <g:if test="${!isErrorHandler}">
                <span class="textbtn textbtn-info"
                      data-bind="click: addFilterPopup"
                      data-stepnum="${stepNum}"
                      title="Add Log Filter">
                    <g:icon name="filter"/>
                </span>
            </g:if>
            <span class="textbtn textbtn-danger "
                  data-toggle="collapse"
                  data-target="#itemdel_${enc(attr:i)}"
                  title="${g.message(code:'Workflow.'+(isErrorHandler?'stepErrorHandler':'step')+'.action.delete.label')}">
                <i class="glyphicon glyphicon-remove"></i></span>

            <span class="textbtn textbtn-info wfitem_copy"  title="${message(code:"workflow.step.action.duplicate.title")}">
                <g:icon name="duplicate"/>
            </span>
            <span class="textbtn textbtn-info wfitem_edit" >
                <i class="glyphicon glyphicon-edit"></i>
                <g:message code="edit" />
            </span>
            <g:unless test="${isErrorHandler}">
                <span class="dragHandle"  title="Drag to reorder"><g:icon name="resize-vertical"/></span>
            </g:unless>
        </span>


        <script type="text/javascript">

        fireWhenReady('wfitem_${enc(js:i)}',function(){
            $('wfitem_${enc(js: i)}').select('span.autoedit').each(function(e){
                Event.observe(e,'click',function(evt){
                    var f=$('workflowContent').down('form');
                    if(!f || 0==f.length){
                        _wfiedit("${enc(js: i)}","${enc(js:stepNum)}",${isErrorHandler?true:false});
                    }
                });
            });
            $('pfctrls_${enc(js: i)}').select('span.wfitem_edit').each(function(e){
                Event.observe(e,'click',function(evt){
                    var f=$('workflowContent').down('form');
                    if(!f || 0==f.length){
                        _wfiedit("${enc(js: i)}","${enc(js:stepNum)}",${isErrorHandler?true:false});
                    }
                });
            });
            $('pfctrls_${enc(js: i)}').select('span.wfitem_copy').each(function(e){
                Event.observe(e,'click',function(evt){
                    var f=$('workflowContent').down('form');
                    if(!f || 0==f.length){
                        _wficopy("${enc(js: i)}","${enc(js:stepNum)}",${isErrorHandler?true:false});
                    }
                });
            });
            $('pfctrls_${enc(js: i)}').select('span.wfitem_add_errorhandler').each(function(e){
                Event.observe(e,'click',function(evt){
                    var f=$('workflowContent').down('form');
                    if(!f || 0==f.length){
                        _wfishownewErrorHandler("${enc(js: i)}","${enc(js:stepNum)}",${!!item.nodeStep});
                    }
                });
            });
            });
        </script>
    </g:if>
        <div class="clear"></div>

            <g:if test="${!isErrorHandler && edit}">
                <div id="logFilter_${enc(attr:i)}">
                <!-- ko if: filters().length -->
                    <span class="text-muted">Log Filters:</span>
                <!-- /ko -->
                <!-- ko foreach: filters -->
                <span class="btn btn-xs btn-info-hollow"
                      data-bind="click: $root.editFilter">
                    <!-- ko if: plugin() -->
                    <!-- ko with: plugin() -->
                    <!-- ko if: iconSrc -->
                    <img width="16px" height="16px" data-bind="attr: {src: iconSrc}"/>
                    <!-- /ko -->
                    <!-- ko if: !iconSrc() -->
                    <i class="rdicon icon-small plugin"></i>
                    <!-- /ko -->
                    <!-- /ko -->
                    <!-- /ko -->


                    <span data-bind="text: title"></span>
                </span>
                <span class="textbtn textbtn-danger"
                      data-bind="click: $root.removeFilter"
                      title="Remove Filter"
                >
                    <g:icon name="remove"/>
                </span>

                <!-- /ko -->
                <!-- ko if: filters().length -->
                    <span class="textbtn textbtn-success" data-bind="click: addFilterPopup">
                      <g:icon name="plus"/>
                      add
                    </span>
                    <!-- /ko -->
                <g:embedJSON id="logFilterData_${enc(attr:i)}" data="${[
                        num:i,
                        description:item.description,
                        filters:item?.getPluginConfigForType('LogFilter')?:[]]
                }"/>
                <script type="text/javascript">
                fireWhenReady("pfctrls_${enc(attr:i)}",function(){
                    var step=workflowEditor.bindStepFilters('logfilter_${i}','logFilter_${enc(attr:i)}',loadJsonData('logFilterData_${enc(attr:i)}'));
                    var elemId="pfctrls_${enc(attr:i)}";
                    ko.applyBindings(step,document.getElementById(elemId));
                });
                </script>
                </div>
            </g:if>
</div>
</div>
