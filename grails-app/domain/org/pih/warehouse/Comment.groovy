package org.pih.warehouse

class Comment {

	Date sendDate 
	String comment
	User commenter
	User recipient
	
	String toString() { return "$comment"; }
	
	static constraints = {
		comment(nullable:false)
		commenter(nullable:true)
		recipient(nullable:true)
		sendDate(nullable:true)		
	}
}