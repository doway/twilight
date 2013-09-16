using System;
using System.Text;
using System.Web.Mvc;
using System.Web.Mvc.Html;
using Twilight.Common.Constants;

namespace Twilight.Common.Helper
{
	public static class PagerHelper
	{
		private static readonly string currentPageStr = "page";

		#region MvcSimplePager

		/// <summary>
		/// Pager display
		/// </summary>
		/// <param name="html"></param>
		/// <param name="pageSize">display of per page</param>
		/// <param name="totalCount">total count</param>
		/// <returns></returns>
		public static string MvcSimplePager(this HtmlHelper html, int pageSize, int totalCount)
		{
			return MvcSimplePager(html, pageSize, totalCount, false);
		}

		/// <summary>
        /// display of per page
		/// </summary>
		/// <param name="html">The HTML.</param>
		/// <param name="pageSize">page size</param>
		/// <param name="totalCount">total count</param>
		/// <param name="showNumberLink">see if show num link</param>
		/// <returns></returns>
		public static string MvcSimplePager(this HtmlHelper html, int pageSize, int totalCount, bool showNumberLink)
		{
			var queryString = html.ViewContext.HttpContext.Request.QueryString;

			//current page
			int currentPage = 1;

			//total page count
			var totalPages = Math.Max((totalCount + pageSize - 1) / pageSize, 1);

            // get current RouteValueDictionary from ViewContext.RouteData.Values
			var routeValueDict = new System.Web.Routing.RouteValueDictionary(html.ViewContext.RouteData.Values);

			var _renderPager = new StringBuilder();

			if (!string.IsNullOrEmpty(queryString[currentPageStr]))
			{
				//binding with queryString
				foreach (string key in queryString.Keys)
				{
					if (queryString[key] != null && !string.IsNullOrEmpty(key))
					{
						routeValueDict[key] = queryString[key];
					}
				}
				int.TryParse(queryString[currentPageStr], out currentPage);
			}
			else
			{
				//get page number ～/Page/{page number}
				if (routeValueDict.ContainsKey(currentPageStr))
				{
					int.TryParse(routeValueDict[currentPageStr].ToString(), out currentPage);
				}
			}

			//keep querystring to next page
			foreach (string key in queryString.Keys)
			{
				routeValueDict[key] = queryString[key];
			}

			if (currentPage <= 0)
			{
				currentPage = 1;
			}

			string emptyAtagFormat = "<a href=\"#\" style=\"cursor:pointer;\">{0}</a>";

			if (totalPages == 1)
			{
				_renderPager.AppendFormat(emptyAtagFormat, MBConfig.FIRST_PAGE);
                _renderPager.AppendFormat(emptyAtagFormat, MBConfig.PREVIOUS_PAGE);
                _renderPager.AppendFormat(emptyAtagFormat, MBConfig.NEXT_PAGE);
                _renderPager.AppendFormat(emptyAtagFormat, MBConfig.LAST_PAGE);
			}
			else if (totalPages > 1)
			{
				if (currentPage != 1)
				{
					//first page
					routeValueDict[currentPageStr] = 1;
                    _renderPager.Append(html.RouteLink(MBConfig.FIRST_PAGE, routeValueDict));
				}
				else
				{
					_renderPager.AppendFormat(emptyAtagFormat, MBConfig.FIRST_PAGE);
				}

				if (currentPage > 1)
				{
					//previous page
					routeValueDict[currentPageStr] = currentPage - 1;
                    _renderPager.Append(html.RouteLink(MBConfig.PREVIOUS_PAGE, routeValueDict));
				}
				else
				{
                    _renderPager.AppendFormat(emptyAtagFormat, MBConfig.PREVIOUS_PAGE);
				}

				#region page numbers
				if (showNumberLink)
				{
					var pageCount = (int)Math.Ceiling(totalCount / (double)pageSize);
					const int nrOfPagesToDisplay = 10;

					var start = 1;
					var end = pageCount;

					if (pageCount > nrOfPagesToDisplay)
					{
						var middle = (int)Math.Ceiling(nrOfPagesToDisplay / 2d) - 1;
						var below = (currentPage - middle);
						var above = (currentPage + middle);

						if (below < 4)
						{
							above = nrOfPagesToDisplay;
							below = 1;
						}
						else if (above > (pageCount - 4))
						{
							above = pageCount;
							below = (pageCount - nrOfPagesToDisplay);
						}

						start = below;
						end = above;
					}

					if (start > 3)
					{
						routeValueDict[currentPageStr] = "1";
						_renderPager.Append(html.RouteLink("1", routeValueDict));

						routeValueDict[currentPageStr] = "2";
						_renderPager.Append(html.RouteLink("2", routeValueDict));
						
						_renderPager.Append("...");
					}

					for (var i = start; i <= end; i++)
					{
						if (i == currentPage || (currentPage <= 0 && i == 0))
						{
							_renderPager.AppendFormat("<span class=\"current\">{0}</span>", i);
						}
						else
						{
							routeValueDict[currentPageStr] = i.ToString();
							_renderPager.Append(html.RouteLink(i.ToString(), routeValueDict));
						}
					}
					if (end < (pageCount - 3))
					{
						_renderPager.Append("...");

						routeValueDict[currentPageStr] = (pageCount - 1).ToString();
						_renderPager.Append(html.RouteLink((pageCount - 1).ToString(), routeValueDict));

						routeValueDict[currentPageStr] = pageCount.ToString();
						_renderPager.Append(html.RouteLink(pageCount.ToString(), routeValueDict));
					}
				}
				#endregion

				if (currentPage < totalPages)
				{
					//next page
					routeValueDict[currentPageStr] = currentPage + 1;
                    _renderPager.Append(html.RouteLink(MBConfig.NEXT_PAGE, routeValueDict));
				}
				else
				{
                    _renderPager.AppendFormat(emptyAtagFormat, MBConfig.NEXT_PAGE);
				}

				if (currentPage != totalPages)
				{
					routeValueDict[currentPageStr] = totalPages;
                    _renderPager.Append(html.RouteLink(MBConfig.LAST_PAGE, routeValueDict));
				}
				else
				{
                    _renderPager.AppendFormat(emptyAtagFormat, MBConfig.LAST_PAGE);
				}
			}

			// currenct page / total page
			_renderPager.AppendFormat("   {0} / {1}  Total {2} records", currentPage, totalPages, totalCount);

			return _renderPager.ToString();
		}

		#endregion

		#region MvcSimplePostPager

		/// <summary>
		/// Pagers the specified HTML using POST.
		/// </summary>
		/// <param name="html">The HTML.</param>
		/// <param name="pageSize">Size of the page.</param>
		/// <param name="totalCount">The total count.</param>
		/// <returns></returns>
		public static string MvcSimplePostPager(this HtmlHelper html, int currentPage, int pageSize, int totalCount)
		{
			return MvcSimplePostPager(html, currentPage, pageSize, totalCount, false);
		}

		/// <summary>
		/// Pagers the specified HTML using POST.
		/// </summary>
		/// <param name="html">The HTML.</param>
		/// <param name="currentPage">The current page.</param>
		/// <param name="pageSize">Size of the page.</param>
		/// <param name="totalCount">The total count.</param>
		/// <param name="showNumberLink">if set to <c>true</c> [show number link].</param>
		/// <returns></returns>
		public static string MvcSimplePostPager(this HtmlHelper html, int currentPage, int pageSize, int totalCount, bool showNumberLink)
		{
			if (totalCount == 0)
			{
				return string.Empty;
			}
			else
			{
				currentPage++;

				//total records
				var totalPages = Math.Max((totalCount + pageSize - 1) / pageSize, 1);

				var _renderPager = new StringBuilder();

				if (currentPage <= 0)
				{
					currentPage = 1;
				}

				string emptyAtagFormat = "<a href=\"#\" style=\"cursor:pointer;\">{0}</a>";

				if (totalPages == 1)
				{
					_renderPager.AppendFormat(emptyAtagFormat, MBConfig.FIRST_PAGE);
                    _renderPager.AppendFormat(emptyAtagFormat, MBConfig.PREVIOUS_PAGE);
                    _renderPager.AppendFormat(emptyAtagFormat, MBConfig.NEXT_PAGE);
                    _renderPager.AppendFormat(emptyAtagFormat, MBConfig.LAST_PAGE);
				}
				else if (totalPages > 1)
				{
					#region first page

					if (currentPage != 1)
					{
                        _renderPager.AppendFormat("<a class=\"PostPager first-page\" style=\"cursor:pointer;\" value=1>{0}</a>", MBConfig.FIRST_PAGE);
					}
					else
					{
						_renderPager.AppendFormat(emptyAtagFormat, MBConfig.FIRST_PAGE);
					} 
					#endregion

					#region previous page
					
					if (currentPage > 1)
					{
                        _renderPager.AppendFormat("<a class=\"PostPager previous-page\" style=\"cursor:pointer;\" value=\"{0}\">{1}</a>", currentPage - 1, MBConfig.PREVIOUS_PAGE);
					}
					else
					{
                        _renderPager.AppendFormat(emptyAtagFormat, MBConfig.PREVIOUS_PAGE);
					} 
					#endregion

					#region link of pages
					if (showNumberLink)
					{
						var pageCount = (int)Math.Ceiling(totalCount / (double)pageSize);
						const int nrOfPagesToDisplay = 10;

						var start = 1;
						var end = pageCount;

						if (pageCount > nrOfPagesToDisplay)
						{
							var middle = (int)Math.Ceiling(nrOfPagesToDisplay / 2d) - 1;
							var below = (currentPage - middle);
							var above = (currentPage + middle);

							if (below < 4)
							{
								above = nrOfPagesToDisplay;
								below = 1;
							}
							else if (above > (pageCount - 4))
							{
								above = pageCount;
								below = (pageCount - nrOfPagesToDisplay);
							}

							start = below;
							end = above;
						}

						if (start > 3)
						{
                            _renderPager.AppendFormat("<a class=\"PostPager number-page\" style=\"cursor:pointer;\" value=\"{0}\">{0}</a>", "1");
                            _renderPager.AppendFormat("<a class=\"PostPager number-page\" style=\"cursor:pointer;\" value=\"{0}\">{0}</a>", "2");
							_renderPager.Append("...");
						}

						for (var i = start; i <= end; i++)
						{
							if (i == currentPage || (currentPage <= 0 && i == 0))
							{
								_renderPager.AppendFormat("<span class=\"current\">{0}</span>", i);
							}
							else
							{
                                _renderPager.AppendFormat("<a class=\"PostPager number-page\" style=\"cursor:pointer;\" value=\"{0}\">{0}</a>", i.ToString());
							}
						}
						if (end < (pageCount - 3))
						{
							_renderPager.AppendFormat("...");
                            _renderPager.AppendFormat("<a class=\"PostPager number-page\" style=\"cursor:pointer;\" value=\"{0}\">{0}</a>", (pageCount - 1).ToString());
                            _renderPager.AppendFormat("<a class=\"PostPager number-page\" style=\"cursor:pointer;\" value=\"{0}\">{0}</a>", pageCount.ToString());
						}
					}
					#endregion

					#region next page
					
					if (currentPage < totalPages)
					{
                        _renderPager.AppendFormat("<a class=\"PostPager next-page\" style=\"cursor:pointer;\" value=\"{0}\">{1}</a>", currentPage + 1, MBConfig.NEXT_PAGE);
					}
					else
					{
						_renderPager.AppendFormat(emptyAtagFormat, MBConfig.NEXT_PAGE);
					}
					
					#endregion

					#region last page
					if (currentPage != totalPages)
					{
                        _renderPager.AppendFormat("<a class=\"PostPager last-page\" style=\"cursor:pointer;\" value=\"{0}\">{1}</a>", totalPages , MBConfig.LAST_PAGE);
					}
					else
					{
						_renderPager.AppendFormat(emptyAtagFormat, MBConfig.LAST_PAGE);
					} 
					#endregion
				}

				// current page index / total pages
				_renderPager.AppendFormat("  {0} / {1}   total {2} records", currentPage, totalPages, totalCount);

				return _renderPager.ToString();
			}
		}

		#endregion
	}
}