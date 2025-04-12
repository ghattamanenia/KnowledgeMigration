var $jq = jQuery.noConflict(true);

var SFSupport = {

	init: function() {

		// DOM init
		if($jq('.createSFSupportCase.Data').length) {
			$jq('<div class="headerHelpTxt"></div>').text('Only pre-authorized users may request a data upload.').appendTo('.createSFSupportCase.Data .pbHeader table>tbody>tr>td:first');
		}

		if($jq('.createSFSupportCase.Enhancement').length) {
			$jq('select[id $= "effectedBusinessProcess_selected"] option').each(function() {
				if($jq(this).text() == 'Other') {
					$jq('textarea[id $= "defineBusinessProcess"]').show();
				}
			});		
		}

		if($jq('.dataTypeSelect').val() != '') {
			$jq('.dataTypeSelect').siblings('textarea').show();
		}



		// if($jq('.employeeName').length) {
		// 	$jq('.employeeName .lookupInput').find('input').addClass('requiredField');
		// }	

		// Need more stable & flexible way to handle this
		$jq(window).load(function() {

			if($jq('.lookupInput').length) {
				$jq('.lookupInput').find('input').addClass('requiredField');
			}	

			if($jq('.lookupInput:visible > select').length) {
				$jq('.lookupInput:visible > select').show();
			}  
				
			$jq("input:radio:checked:visible").each(function() {
				if($jq(this).val() == 'Yes') {
					$jq(this).parents('fieldset').closest('tr').next().find('.hide > div').show();
				}
				else {
					$jq(this).parents('fieldset').closest('tr').next().find('.hide > div > textarea, .hide > div > input').html('');
					if($jq(this).parents('fieldset').closest('tr').next().find('.hide > div').next().hasClass('errorMsg')) {
						$jq(this).parents('fieldset').closest('tr').next().find('.hide > div').next().remove();
					}
				}
			});

			// Events init
			$jq("input:radio").change(function() {
				var $hiddenSec = $jq(this).parents('fieldset').closest('tr').next().find('.hide').find('>div');

				$hiddenSec.slideToggle();

				if($hiddenSec.find('.errorField').length) {
					SFSupport.removeError($hiddenSec);
				}
			});

			$jq('.currency:visible').each(function() {
				var $this = $jq(this);
				if($this.val() && $this.val() != 0) {
					$this.closest('tr').next().find('.hide > div').show();
				}
			});

			$jq('.currency').each(function() {

				$jq(this).on('keyup', function() {
					var $this = $jq(this),
						$hiddenSec = $this.closest('tr').next().find('.hide').find('>div');	

					if($jq.trim($this.val())) {
						if(!$jq.isNumeric($this.val()) && !$this.siblings('.errorMsg').length) {
							var $errorMsg = $jq('<div class="errorMsg"><strong>Error:</strong> You must enter a number</div>');				
							
							$this.addClass('errorField').closest('td').append($errorMsg);
						}
						else if($jq.isNumeric($this.val()) || !$this.val()) {

							SFSupport.removeError($this);
						}
					} 
					else if(!$jq.trim($this.val()) && $this.siblings().hasClass('errorMsg')) {
						SFSupport.removeError($this);
					}

					if($jq.isNumeric($this.val()) && $this.val() != 0 && !$hiddenSec.is(':visible')) {
						$hiddenSec.slideDown();
					}
					else if((!$this.val() || $this.val() == 0) && $hiddenSec.is(':visible')) {
						
						if($hiddenSec.find('textarea').val()) {
							// if(!window.confirm('Warning: if you submit this Enhancement Request without a currency value, text entered in the supporting calculations field will not be submitted.')) {
							// 	return;
							// }		
							alert('Warning: if you submit this Enhancement Request without a currency value, text entered in the supporting calculations field will not be submitted.');				
						}

						$hiddenSec.slideUp();
			
						if($hiddenSec.find('.errorField').length) {
							SFSupport.removeError($hiddenSec);
						}
					}			
				});
			});		

			// TODO: Combine this with other event handler
			$jq('.dataTypeSelect').on('change', function() {   
				if($jq(this).val() != '') {
					var $textarea = $jq(this).siblings('textarea').fadeIn(200);
					
					if($jq(this).val() == 'Other') {
						//Space is needed to break the line in placeholder
						$textarea.addClass('requiredField').attr('placeholder', 'What type of data do you wish to upload? ' + '              ' + ' Optionally add comments');
					}
					else {
						$textarea.removeClass('requiredField').attr('placeholder', 'Optional Comments');				
					}
				}
				else {
					$jq(this).siblings('textarea').fadeOut(200);
					if($jq(this).siblings('.errorMsg').length) {
						$jq(this).siblings('.errorMsg').remove();
					}
				}
			});

			$jq('.multiSelectPicklistCell').on('click', 'a', function() {
				setTimeout(SFSupport.checkMultiPicklistVal, 500);
			});

			if($jq('.lookupInput > select').length) {
				$jq('.lookupInput > select').val('');

				$jq('.lookupInput > select').on('change', function() {
					if($jq(this).val()) {
						$jq('.lookupInput').siblings('.errorMsg').hide();
					}
					else {
						$jq('.lookupInput').siblings('.errorMsg').show();				
					}
				});
			}
		});	
	},
	// Called from VF page
	// TODO: Combine this with other validations after make it to modular
	validate: function() {
		var $required = $jq('.requiredField'),
			$submitBtn = $jq('.submitBtn'),
			isError = false;
			
		$required.each(function() {
			var $this = $jq(this),
				$errorMsg = $jq('<div class="errorMsg"><strong>Error:</strong> You must enter a value</div>');
			
			if($this.val() == '' && $this.is(':visible') && $this.val() != 'Other') {
				if(!$this.hasClass('errorField')) {

					if($this.prev().val() == 'Other') {
						$errorMsg.css('margin-left', '500px');
					} 

					$this.addClass('errorField').closest('td').append($errorMsg);
				}
				isError = true;
			}
			else if($this.val() && $this.val() != 'Other') {
				$this.removeClass('errorField');
				$this.siblings('.errorMsg').remove();
			}		

			SFSupport.checkVal($this);
		}).promise().done(function() {
			if(isError || $jq('.errorMsg').is(':visible')) {
				$submitBtn.removeAttr('disabled', 'disabled').removeClass('submitting').val('Submit');
				return;
			}
			else {
				var $hiddenInput = $jq('textarea, input:visible').not(':visible');
					
				$hiddenInput.each(function() {
					if($jq.trim($jq(this).val())) {
						$hiddenInput.val('');
					}
				});

				$submitBtn.attr('disabled', 'disabled').addClass('submitting').val('Submitting...');
		 		submitCase();
			}
		});
	},
	checkVal: function($required) { 
		// Check if text was entered
		if($required.prop("tagName") == 'INPUT' || $required.prop("tagName") == 'TEXTAREA') {
			$required.on('keyup', function() {
				var $this = $jq(this);
				
				if($this.hasClass('errorField') && $this.val() != '') {
					$this.removeClass('errorField');

					if($this.hasClass('activeDate') || $this.closest('.hide').length) {
						$this.parent().siblings('.errorMsg').remove();
					}  
					else {
						$this.siblings('.errorMsg').remove();							
					}
				}
				if($this.attr('title') == "Requestor Name") {
					if($this.closest('.hide').find('.errorMsg').length) {
						$this.closest('.hide').find('.errorMsg').remove();
					}
				}
			});		
		}

		// Check if value was selected, or text was entered	
		if($required.parents('.lookupInput').length || $jq('.activeDate').length) {
			$required.on('focus', function() {
				var $this = $jq(this);
				
				if($this.hasClass('errorField') && $this.val() != '') {
					$this.removeClass('errorField');
					$this.closest('td').children('.errorMsg').remove();	
				}
			});		
		}

		// Check if option was selected	
		if($required.prop("tagName") == 'SELECT') {
			$required.on('change', function() {
				var $this = $jq(this);
				
				if($this.hasClass('errorField') && $this.val() != '') {
					$this.removeClass('errorField');
					$this.siblings('.errorMsg').remove();			
				}
			});		
		}
	},	
	checkMultiPicklistVal: function() {
		var $unselected = $jq('select[id $= "effectedBusinessProcess_unselected"]'),
			$selected = $jq('select[id $= "effectedBusinessProcess_selected"]'),
			$textarea = $jq('textarea[id $= "defineBusinessProcess"]');	

		$unselected.find('option').each(function() {
			if($jq(this).text() == 'Other' && $textarea.is(':visible')) {
				$textarea.fadeOut(200);
				
				if($textarea.hasClass('errorField')) {
					$textarea.removeClass('errorField').next().remove();
				}
			}
			return;
		});			

		$selected.find('option').each(function() {
			if($jq(this).text() == 'Other' && !$textarea.is(':visible')) {
				$textarea.fadeIn(200);
			}
			return;
		});			
	},
	removeError: function($errorSec) {
		var $errorMsg = $errorSec.siblings('.errorMsg');

		if($errorMsg.length) {
			$errorMsg.closest('td').find('.errorField').removeClass('errorField');				
			$errorMsg.remove();
		}
	}

};
SFSupport.init();