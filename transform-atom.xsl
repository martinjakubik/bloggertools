<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" xmlns:thr='http://purl.org/syndication/thread/1.0' xmlns:georss='http://www.georss.org/georss' xmlns:gd='http://schemas.google.com/g/2005' extension-element-prefixes="exsl" version="1.0">

    <xsl:output method="html"/>

    <xsl:template match="/">
        <xsl:apply-templates select="/feed/entry" />
    </xsl:template>

    <xsl:template match="entry[category/@term='http://schemas.google.com/blogger/2008/kind#template']">
    </xsl:template>
    
    <xsl:template match="entry[category/@term='http://schemas.google.com/blogger/2008/kind#settings']">
    </xsl:template>
    
    <xsl:template match="entry[category/@term='http://schemas.google.com/blogger/2008/kind#comment']">
    </xsl:template>
    
    <xsl:template match="entry[category/@term='http://schemas.google.com/blogger/2008/kind#post']">
        <xsl:variable name="postId" select="id"></xsl:variable>
        <xsl:variable name="postYear" select="substring(published, 1, 4)"></xsl:variable>
        <xsl:variable name="postMonth" select="substring(published, 6, 2)"></xsl:variable>
        <xsl:variable name="postShortId" select="substring-after(substring-after(id, '-'), '-')"></xsl:variable>
        <xsl:variable name="postVeryShortId" select="substring($postShortId, 1, 6)"></xsl:variable>
        <xsl:variable name="postFilenameCandidate" select="concat(substring(translate(translate(title, ' ', '-'), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ;:?!,+#$', 'abcdefghijklmnopqrstuvwxyz-------'), 1, 16), $postVeryShortId)"></xsl:variable>
        <xsl:variable name="postFilename">
            <xsl:choose>
                <xsl:when test="string-length(title) > 0">
                    <xsl:value-of select="$postFilenameCandidate" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$postShortId" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <exsl:document href="./{$postYear}/{$postMonth}/{$postFilename}.html">
            <div class="post">
                <div class="postTitle"><xsl:value-of select="title" /></div>
                <div class="metadata">
                    <div class="postDatePublished"><xsl:value-of select="published" /></div>
                    <div class="postDateUpdated"><xsl:value-of select="updated" /></div>
                    <div class="postId"><xsl:value-of select="id" /></div>
                </div>
                <div class="postContent">
                    <xsl:value-of select="content" disable-output-escaping="yes" />
                </div>
                <div class="comments">
                    <xsl:for-each select="/feed/entry[thr:in-reply-to/@ref=$postId]">
                        <div class="comment">
                            <div class="commentTitle"><xsl:value-of select="title" /></div>
                            <div class="metadata">
                                <div class="commentDatePublished"><xsl:value-of select="published" /></div>
                                <div class="commentDateUpdated"><xsl:value-of select="updated" /></div>
                                <div class="commentId"><xsl:value-of select="id" /></div>
                            </div>
                            <div class="commentContent"><xsl:value-of select="content" /></div>
                        </div>
                    </xsl:for-each>
                </div>
            </div>
        </exsl:document>
    </xsl:template>
    
  </xsl:stylesheet>