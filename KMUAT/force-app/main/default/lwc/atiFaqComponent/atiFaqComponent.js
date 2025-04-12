import { LightningElement, wire, track } from 'lwc';
import getFAQsByCategory from '@salesforce/apex/FAQController.getFAQsByCategory';
import getCategories from '@salesforce/apex/FAQController.getCategories';

export default class FaqCategories extends LightningElement {
    @track categoriesWithFAQs = [];

    connectedCallback() {
        this.loadCategoriesAndFAQs();
    }

    // Fetch categories and their respective FAQs
    async loadCategoriesAndFAQs() {
        try {
            const categories = await getCategories();

            // Process categories
            const categoriesWithFAQs = await Promise.all(
                categories.map(async (category) => {
                    const faqs = await getFAQsByCategory({ category, offset: 0, fetchLimit: 50 });
                    return {
                        category,
                        faqs: faqs.map((faq) => ({
                            ...faq,
                            isExpanded: false, // Initialize collapsed state
                        })),
                    };
                })
            );

            this.categoriesWithFAQs = categoriesWithFAQs;
        } catch (error) {
            console.error('Error loading categories or FAQs: ', error);
        }
    }

    // Toggle the visibility of the answer
    toggleAnswer(event) {
        const faqId = event.currentTarget.dataset.id;
        const categoryIndex = event.currentTarget.dataset.categoryIndex;

        // Update the specific FAQ's isExpanded state
        this.categoriesWithFAQs = this.categoriesWithFAQs.map((cat, index) => {
            if (index === parseInt(categoryIndex, 10)) {
                return {
                    ...cat,
                    faqs: cat.faqs.map((faq) =>
                        faq.Id === faqId ? { ...faq, isExpanded: !faq.isExpanded } : faq
                    ),
                };
            }
            return cat;
        });
    }
}