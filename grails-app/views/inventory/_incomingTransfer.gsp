<div class="box">
    <h2><warehouse:message code="inventory.incomingTransfer.label"/></h2>

	<g:form action="saveCreditTransaction">
		<g:hiddenField name="transactionInstance.id" value="${command?.transactionInstance?.id}"/>
		<g:hiddenField name="transactionInstance.inventory.id" value="${command?.warehouseInstance?.inventory?.id}"/>
		<g:hiddenField name="transactionInstance.transactionType.id" value="${command?.transactionInstance?.transactionType?.id }"/>


		<table>
			<tr class="prop">
				<td class="name">
					<label><warehouse:message code="transaction.date.label"/></label>
				</td>
				<td class="value">

                    <%--
					<span class="transactionDate">
						<g:jqueryDatePicker id="transactionDate" name="transactionInstance.transactionDate"
							value="${command?.transactionInstance?.transactionDate}" format="MM/dd/yyyy"/>
					</span>
				    --%>
                    <g:datePicker name="transactionInstance.transactionDate" value="${command?.transactionInstance?.transactionDate}" precision="minute" noSelection="['':'']"/>
				</td>
			</tr>	
			<tr class="prop">
				<td class="name">
					<label><warehouse:message code="default.from.label"/></label>
				</td>
				<td class="value">			

					<g:selectTransactionSource name="transactionInstance.source.id"
                        class="chzn-select-deselect"
						optionKey="id" optionValue="name" value="${command?.transactionInstance?.source?.id}" noSelection="['null': '']" />
							
				</td>
			</tr>
			<tr class="prop">
				<td class="name">
					<label><warehouse:message code="transaction.comment.label"/></label>
				</td>
				<td class="value">
					<span class="comment">
						<g:textArea cols="100%" rows="10" name="transactionInstance.comment"
							value="${command?.transactionInstance?.comment }"></g:textArea>

					</span>								
				</td>
			</tr>				
			<tr class="prop">
				<td class="name">
					<%-- 
					<label><warehouse:message code="transaction.transactionEntries.label"/></label>
					--%>
				</td>
				<td style="padding: 0px;">
					<div class="transactionEntries">
						<table id="incomingTransfer" >
							<thead>
								<tr class="odd">
									<th class="left">
										<warehouse:message code="product.label"/>
									</th>
									<th>
										<warehouse:message code="product.lotNumber.label"/> / 
										<warehouse:message code="default.expires.label"/>
									</th>
									<th><warehouse:message code="default.qty.label"/></th>
									<th><warehouse:message code="default.actions.label"/></th>
								</tr>
							</thead>
							<tbody>
								<g:set var="status" value="${0 }"/>
								
								<%-- Generate row based on transaction entries --%>
								<g:if test="${command?.transactionEntries }">								
									<g:each var="transactionEntry" in="${command?.transactionEntries }" status="i">
										<g:hiddenField name="product.id" value="${transactionEntry?.product?.id }"/>
										<tr class="prop row">
											<td class="left">
												<span class="productName">
													<format:product product="${transactionEntry?.product}"/>
												</span>
												<g:hiddenField name="transactionEntries[${i }].product.id" 
													value="${transactionEntry?.product?.id}"/>
											</td>
											<td width="50%">
												<g:set var="displayLotNumberEditor" value="${!transactionEntry?.inventoryItem && !transactionEntry?.lotNumber}"/>
												<g:set var="displayLotNumberReadonly" value="${!displayLotNumberEditor}"/>

												<span class="lotNumberSelector" style="${displayLotNumberReadonly || displayLotNumberEditor?'display:none;':''}">
													<select class="inventoryItem" name="transactionEntries[${i }].inventoryItem.id">
														<option value="-1"></option>
														<g:each var="inventoryItem" in="${command?.productInventoryItems[transactionEntry?.product]?.sort { it.expirationDate } }">
															<g:set var="selected" value="${transactionEntry?.inventoryItem==inventoryItem}"/>
															<option value="${inventoryItem?.id }" ${selected?'selected=selected':'' }>
																${inventoryItem?.lotNumber ?: warehouse.message(code: 'inventory.noLotNumber.message') }
																<g:if test="${inventoryItem?.expirationDate }"> 
																	(<warehouse:message code="default.expires.label"/> 
																		<format:date obj="${inventoryItem?.expirationDate }" format="MMM yyyy"/>)
																</g:if>
															</option>														
														</g:each>
														<option value="0">${warehouse.message(code: 'inventory.enterLotOrSerialNumber.label') }</option>
													</select>
												</span>

												<span class="lotNumberEditor" style="${!displayLotNumberEditor?'display:none;':'' }">
													<g:textField class="lotNumber" name="transactionEntries[${i }].lotNumber" 
														value="${transactionEntry?.lotNumber }"/>
														
													<g:datePicker name="transactionEntries[${i }].expirationDate" precision="month" noSelection="['':'']"
														value="${transactionEntry?.expirationDate }" years="${(1900 + (new Date().year))..(1900+ (new Date() + (20 * 365)).year)}"/>											
													
													<img class="undo middle" src="${createLinkTo(dir:'images/icons/silk',file:'decline.png')}" title="${warehouse.message(code: 'cancel.label') }" alt="${warehouse.message(code: 'cancel.label') }"/>
												</span>	
												
												<span class="lotNumberReadonly" style="${!displayLotNumberReadonly?'display:none;':'' }">
													<g:if test="${transactionEntry?.inventoryItem }">
														<span class="lotNumber">${transactionEntry?.inventoryItem?.lotNumber ?: warehouse.message(code: 'inventory.noLotNumber.message')}</span>
														
														<g:if test="${transactionEntry?.inventoryItem?.expirationDate }">
															<span class="expirationDate fade">
																(<warehouse:message code="default.expires.label"/> 
																	<format:date obj="${transactionEntry?.inventoryItem?.expirationDate }" format="MMM yyyy"/>)
															</span>
														</g:if>
													</g:if>
													<g:else>
														<span class="lotNumber">${transactionEntry?.lotNumber ?: warehouse.message(code: 'inventory.noLotNumber.message')}</span>
														<g:if test="${transactionEntry?.expirationDate }">  
															<span class="expirationDate fade">
																(<warehouse:message code="default.expires.label"/> 
																	<format:date obj="${transactionEntry?.expirationDate }" format="MMM yyyy"/>)
															</span>
														</g:if>
													</g:else>
													<img class="undo middle" src="${createLinkTo(dir:'images/icons/silk',file:'pencil.png')}" title="${warehouse.message(code: 'cancel.label') }" alt="${warehouse.message(code: 'undo.label') }"/>
												</span>	
											</td>
											<td>
												<g:textField name="transactionEntries[${i }].quantity" size="5" class="text medium" autocomplete="off" value="${transactionEntry?.quantity }"/>
											</td>
											<td>
												<img class="add middle" src="${createLinkTo(dir:'images/icons/silk',file:'add.png')}" alt="${warehouse.message(code: 'add.label') }"/>
												<img class="delete middle" src="${createLinkTo(dir:'images/icons/silk',file:'delete.png')}" alt="${warehouse.message(code: 'delete.label') }"/>	
											</td>
											<td>
									            <g:hasErrors bean="${transactionEntry}">
										            <div class="errors">
										                <g:renderErrors bean="${transactionEntry}" as="list" />
										            </div>
									            </g:hasErrors>    
											
											</td>
											
										</tr>
									</g:each>
								</g:if>
								<g:else>
									<g:each var="product" in="${command?.productInventoryItems?.keySet() }" status="i">
										<%-- Hidden field used to keep track of the products that were selected --%>
										<g:hiddenField name="product.id" value="${product?.id }"/>
										
										<%-- initial product rows --%>
										<tr class="prop row">
											<td class="left">
												<span class="productName">
													<format:product product="${product }"/>
												</span>
												<g:hiddenField name="transactionEntries[${i }].product.id" value="${product?.id }"/>
											</td>
											<td>										
												<g:set var="displayLotNumberEditor" value="${!command?.transactionEntries[i]?.inventoryItem && command?.transactionEntries[i]?.lotNumber}"/>
												<g:set var="displayLotNumberReadonly" value="${command?.transactionEntries[i]?.inventoryItem}"/>
												
												<span class="lotNumberSelector" style="${displayLotNumberReadonly || displayLotNumberEditor?'display:none;':''}">
													<select class="inventoryItem" name="transactionEntries[${i }].inventoryItem.id">
														<option value="-1"></option>
														<g:each var="inventoryItem" in="${command?.productInventoryItems[product]?.sort { it.expirationDate } }">
															<g:set var="selected" value="${command?.transactionEntries[i]?.inventoryItem==inventoryItem}"/>
															<option value="${inventoryItem?.id }" ${selected?'selected=selected':'' }>
																${inventoryItem?.lotNumber ?: warehouse.message(code: 'inventory.noLotNumber.message')} 
																<g:if test="${inventoryItem?.expirationDate }"> 
																	(<warehouse:message code="default.expires.label"/> 
																		<format:date obj="${inventoryItem?.expirationDate }" format="MMM yyyy"/>)
																</g:if>
															</option>														
														</g:each>
														<option value="0">${warehouse.message(code: 'inventory.enterLotOrSerialNumber.label') }</option>
													</select>
												</span>
												
												<span class="lotNumberEditor" style="${!displayLotNumberEditor?'display:none;':'' }">
													<g:textField class="lotNumber" name="transactionEntries[${i }].lotNumber" 
														value="${command?.transactionEntries[i]?.lotNumber }"/>
														
													<g:datePicker name="transactionEntries[${i }].expirationDate" precision="month" noSelection="['':'']"
														value="${command?.transactionEntries[i]?.expirationDate }" years="${(1900 + (new Date().year))..(1900+ (new Date() + (20 * 365)).year)}"/>											
																										
													<img class="undo middle" src="${createLinkTo(dir:'images/icons/silk',file:'decline.png')}" alt="${warehouse.message(code: 'cancel.label') }"/>
												</span>	
												
												<span class="lotNumberReadonly" style="${!displayLotNumberReadonly?'display:none;':'' }">
													<span class="lotNumber">${command?.transactionEntries[i]?.inventoryItem?.lotNumber}</span>
													
													${command?.transactionEntries[i]?.inventoryItem?.expirationDate}
													<g:if test="${command?.transactionEntries[i]?.inventoryItem?.expirationDate }"> 
														<span class="expirationDate fade">
															(<warehouse:message code="default.expires.label"/>
																<format:date obj="${command?.transactionEntries[i]?.inventoryItem?.expirationDate}" format="MMM yyyy"/>)
														</span>
													</g:if>
													<img class="undo middle" src="${createLinkTo(dir:'images/icons/silk',file:'pencil.png')}" alt="${warehouse.message(code: 'undo.label') }"/>
												</span>	
											</td>
											<td>
												<g:textField name="transactionEntries[${i }].quantity" size="5" class="text medium" autocomplete="off" value="${command?.transactionEntries[i]?.quantity }"/>
											</td>
											<td>
												<img class="add middle" src="${createLinkTo(dir:'images/icons/silk',file:'add.png')}" alt="${warehouse.message(code: 'add.label') }"/>
												<img class="delete middle" src="${createLinkTo(dir:'images/icons/silk',file:'delete.png')}" alt="${warehouse.message(code: 'delete.label') }"/>	
											</td>
										</tr>
									</g:each>
								</g:else>
							</tbody>
						</table>
					</div>	
				</td>
			</tr>		
			<tr class="prop">
				<td colspan="7">
					<div class="center">
						<button type="submit" name="save" class="button icon approve">
							<warehouse:message code="default.button.save.label"/>
						</button>
						&nbsp;
						<g:link controller="inventory" action="browse">
							${warehouse.message(code: 'default.button.cancel.label')}
						</g:link>
					</div>
				</td>
			</tr>
		</table>				
	</g:form>
</div>
<script>
	$(document).ready(function() {
				
		var cloneRow = function($table, $tableRow) { 
			// Replace all rows 
			var newTableRow = $tableRow.clone().find("input,select").each(function() {
		    	//var nextIndex = $("tr.row").length;
			    //var oldName = $(this).attr('name');
			    //var newName = oldName.replace("/(transactionEntries\[)(\d+)(\])/", function(f, p1, p2, p3) {
			    //	return p1 + nextIndex + p3;
			    //});
		        //$(this).attr('name', newName);
		    }).end();

			// Remove the add button
			//newTableRow.find("img.add").remove();
			
			// Remove product name
			//newTableRow.find("span.productName").remove();
			
			// Show the lot number selector 
			newTableRow.find(".lotNumberSelector").show().find(".inventoryItem").val("");
			newTableRow.find(".lotNumberReadonly").hide();
			newTableRow.find(".lotNumberEditor").hide();

		    // Add new cloned row to table
			newTableRow.insertAfter($tableRow);

			// Rename all of the fields 
			renameRowFields($table);
			//newTableRow.appendTo($table.find("tbody"));
		}	

		/**
		 * Initialize all lot number fields 
		 * TODO Need to be i18n'd.
		 */
		$(".lotNumber").watermark('${warehouse.message(code:'transaction.addNewLotSerialNumber.label')}');		

		/**
		 * Initialize the table used to hold all transaction entries
		 */					
		alternateRowColors("#incomingTransfer");

		/**
		 * Delete a row from the table.
		 */		
		$("img.delete").livequery('click', function(event) { 
			$(this).closest('tr').fadeTo(400, 0, function () { 
		        $(this).remove();
				alternateRowColors("#incomingTransfer");
				renameRowFields($("#incomingTransfer"));
		    });
		    return false;
		});			
				

		/**
		 * Add a new row to the table.
		 */
		$("img.add").livequery('click', function(event) {
			cloneRow($("#incomingTransfer"), $(this).closest('tr'));			
			alternateRowColors("#incomingTransfer");
		});
		
		
		/**
		 * Undo inventory item selection
		 */
		$("img.undo").livequery('click', function(event) { 
			$(this).closest(".lotNumberEditor").hide();
			$(this).closest(".lotNumberReadonly").hide();
			$(this).parent().siblings(".lotNumberSelector").show();

			// Reset to the empty value
			$(this).parent().siblings(".lotNumberSelector").find(".inventoryItem").val("");
		});


		/**
		 * Change event on the inventory item select list.
		 */
		$(".inventoryItem").livequery('change', function() {  
			// TODO dangerous since the value might be "other" if one of the lot number values = "other"
			var value = $(this).attr("value");
			
			// If value = 'Enter a new lot number'
			if (value == "0") { 
				$(this).closest(".lotNumberSelector").hide();
				$(this).parent().siblings(".lotNumberEditor").show();
			}
			else if (value == "") { 

			}
			else { 
				// TODO Need to set the fields in newLotNumber and set them to 'disabled'
				var readonlySpan = $(this).parent().siblings(".lotNumberReadonly");
				
				$.getJSON('${request.contextPath}/json/getInventoryItem/' + value, function(data) {

					var errorMessage = "${warehouse.message(code: 'inventory.noLotNumber.message')}"
					readonlySpan.find(".lotNumber").text(data.lotNumber ? data.lotNumber : errorMessage);
					
					var expMonth = '';
					var expYear = '';
					if (data.expirationDate) {
						var d = new Date(data.expirationDate);
						expMonth = monthNamesShort[d.getMonth()];
						expYear = d.getFullYear()
					}
					
					if (expMonth && expYear) { 
						readonlySpan.find(".expirationDate").text("(${warehouse.message(code: 'default.expires.label')} " + expMonth + " " + expYear + ")");
					}					
				});


				
				// Show new lot number and hide existing lot number
				// TODO Rename existingLotNumber to lotNumberSelect 
				// TODO Rename newLotNumber to lotNumberFields
				$(this).closest(".lotNumberSelector").hide();
				$(this).parent().siblings(".lotNumberReadonly").show();
				$(this).parent().siblings(".lotNumberEditor").hide();
				// Tab to the next field
				//var currentIndex = $(":input").index(this);
				//alert(currentIndex);
				//$(":input:eq(" +  (currentIndex + 1) + ")").focus();
			}
		});


	});
</script>

