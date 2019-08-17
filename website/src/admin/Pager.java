package admin;

public class Pager {

	private int current, count, lbound, ubound;

	public Pager(int current, int per_page, int count){
		this.current = current;
		this.count   = (count % per_page) > 0 ? (count / per_page) + 1 : (count / per_page);
		this.lbound  = (current - 3 > 0 ? current - 3 : 1);
		this.ubound  = (current + 3 < this.count ? current + 3 : this.count);
	}

	public String getPager(){
		StringBuilder pager = new StringBuilder(getForm() + getStart() + (current == 1 ? getDisabledPrev() : getActivePrev()));

		for(int i = lbound; i <= ubound; i++){
			pager.append(current == i ? getSelectedLink(i) : getActiveLink(i));
		}

		pager.append(count == 0 || current == count ? getDisabledNext() : getActiveNext()).append(getEnd());

		return pager.toString();
	}

	public String _getPager(){
		StringBuilder pager = new StringBuilder(getForm() + _getStart() + (current == 1 ? getDisabledPrev() : getActivePrev()));

		for(int i = lbound; i <= ubound; i++){
			pager.append(current == i ? getSelectedLink(i) : getActiveLink(i));
		}

		pager.append(count == 0 || current == count ? getDisabledNext() : getActiveNext()).append(_getEnd());

		return pager.toString();
	}

	private String getForm(){
		return "<form id='pager-form' method='post'>"
			 + "    <input type='hidden' id='pageno' name='pageno' value='" + current + "'>"
			 + "</form>";
	}

	private String getDisabledPrev(){
		return "<li class='page-item disabled'>"
	         + "    <a class='page-link' aria-label='Previous'>"
	         + "        <span aria-hidden='true'>&laquo;</span>"
	         + "        <span class='sr-only'>Previous</span>"
	         + "    </a>"
	         + "</li>";
	}

	private String getActivePrev(){
		return "<li class='page-item'>"
			 + "    <a class='page-link' id='page-prev' aria-label='Previous'>"
			 + "        <span aria-hidden='true'>&laquo;</span>"
			 + "        <span class='sr-only'>Previous</span>"
			 + "    </a>"
			 + "</li>";
	}

	private String getSelectedLink(int i){
		return "<li class='page-item active'><a class='page-link'>"
			 + i
			 + "<span class='sr-only'>(current)</span></a></li>";
	}

	private String getActiveLink(int i){
		return "<li class='page-item'><a class='page-link pager-links'>" + i + "</a></li>";
	}

	private String getDisabledNext(){
		return "<li class='page-item disabled'>"
			 + "    <a class='page-link' aria-label='Next'>"
			 + "        <span aria-hidden='true'>&raquo;</span>"
			 + "        <span class='sr-only'>Next</span>"
			 + "    </a>"
			 + "</li>";
	}

	private String getActiveNext(){
		return "<li class='page-item'>"
			 + "    <a class='page-link' id='page-next' aria-label='Next'>"
			 + "        <span aria-hidden='true'>&raquo;</span>"
			 + "        <span class='sr-only'>Next</span>"
			 + "    </a>"
			 + "</li>";
	}

	private String getStart(){
		return "<div class='container text-center col-lg-12'><hr><ul class='pagination'>";
	}

	private String getEnd(){
		return "</ul><br><br><br><br><br><br></div>";
	}

	private String _getStart(){
		return "<div class='container'><hr><ul class='pagination justify-content-center'>";
	}

	private String _getEnd(){
		return "</ul><br></div>";
	}
}